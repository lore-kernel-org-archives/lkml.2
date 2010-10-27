Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118Ab0J0Jv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 05:51:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42857 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab0J0JvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 05:51:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=VTgcC1X17eGqq9eaXmSqg8MNU95bqkylS8+MYzRYZe9TJwCyXVpfG7cly3aecVrots
         ZVO4YfwnQm27yeJKGGSyN9L3noilEQ2/DOg8XBPleeVy3RbARCIEpVFxae5DIpe4K1Cg
         QBTUrHehU7flRwGPa0xBrh61FQAZSPkCaqIZM=
Message-ID: <4CC7F616.5060404@suse.cz>
Date: Wed, 27 Oct 2010 11:51:18 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.11) Gecko/20101013 SUSE/3.1.5 Thunderbird/3.1.5
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Dr. Werner Fink" <werner@suse.de>
Subject: Re: [PATCH 28/49] tty: Add a new file /proc/tty/consoles
References: <20101022175112.GC13489@kroah.com> <1287771688-14805-28-git-send-email-gregkh@suse.de> <4CC2C9A8.1040003@suse.cz> <20101025075125.GA29179@boole.suse.de> <20101027005045.GC19804@ZenIV.linux.org.uk> <20101027092744.GA27071@boole.suse.de>
In-Reply-To: <20101027092744.GA27071@boole.suse.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2010 11:27 AM, Dr. Werner Fink wrote:
> Such a list would be very helpful e.g. to extend sulogin
> to be able to prompt for maintenance on all terminal lines
> of the system console after e.g. failed fsck.  Currently
> only the preferred terminal line is prompted for maintenance.

I think nobody objects to the /proc/tty/consoles. This is a good thing
to have. The patch just needs to be fixed (and you already did and sent
me in private).

The objections are against the way how you find out the real tty behind
/dev/console. The method to walk through fd, guessing private_data etc.
is simply unacceptable.

Actually couldn't you just use one of:
1) ttyprintk driver (well, this will insert mess into klog)
2) send the output to all enabled consoles in /proc/tty/consoles
?

regards,
-- 
js
suse labs
