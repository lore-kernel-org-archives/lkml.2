Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532Ab1BUKzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 05:55:22 -0500
Received: from mail-bw0-f42.google.com ([209.85.214.42]:51041 "EHLO
	mail-bw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab1BUKzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 05:55:19 -0500
X-Greylist: delayed 485 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Feb 2011 05:55:18 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=iguQuC4nKH++TzPnJJU3xQa57DvnOJYIqL98LLbCXGWyMpi3vMZTf84uKjHg702rRC
         gS0fTylwpiCy2zHzhhBBt22UkE/pzIwtEn6pABtxOLKO5vU5PZZd9VptqobzplzFgZ9R
         AyqQvKBFj+Ls87/KZEGtmtmZeG91FLg+fL13w=
Message-ID: <4D6242AD.2090600@suse.cz>
Date: Mon, 21 Feb 2011 11:47:09 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: jlbec@evilplan.org
CC: npiggin@kernel.dk, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: OOPS in configfs when doing d_delete
References: <4D623C62.8030509@suse.cz> <20110221104359.GA18538@noexit>
In-Reply-To: <20110221104359.GA18538@noexit>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2011 11:44 AM, Joel Becker wrote:
> On Mon, Feb 21, 2011 at 11:20:18AM +0100, Jiri Slaby wrote:
>> when configfs_attach_group fails in configfs_register_subsystem:
>>         dentry = d_alloc(configfs_sb->s_root, &name);
>>         if (dentry) {
>>                 d_add(dentry, NULL);
>>
>>                 err = configfs_attach_group(sd->s_element, &group->cg_item,
>>                                             dentry);
>>                 if (err) {
>>                         d_delete(dentry);
>>                         dput(dentry);
>>
>>
>> d_delete kills the kernel. I don't know what the actual bug is here, but
>> d_delete looks broken anyway:
>>         spin_lock(&dentry->d_lock);
>>         inode = dentry->d_inode;
>>         isdir = S_ISDIR(inode->i_mode);  <======== dereference
>>         if (dentry->d_count == 1) {
>>                 if (inode && !spin_trylock(&inode->i_lock)) {
>>                     ^^^^^  <============= test
>>
>> It seems like a superfluous test, not a potential null dereference to
>> me, right?
> 
> 	I think you're right about the superfluous test, but I need more
> investigation to see what's going on.  Thanks for the report.
> 	What was causing attach_group() to fail?  Do you know?

Dunno, I just modprobe'd the configfs example from Doc dir
(configfs_example_macros).

regards,
-- 
js
suse labs
