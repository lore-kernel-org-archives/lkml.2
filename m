Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab0EGGHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 02:07:47 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:56262 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab0EGGHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 02:07:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=BK5Y/5QqJZ6xkhSt+j/dlZ9ncdzK5IwrahwmIizzJOiJVNdKCxl8fdrLM8srzCeJuk
         fC3dOv53W2Vmw+9kdHxqSGBUq8UcVhLYFsLDzfppNFzkmlN/tNhzgossBvmUnswpM5zO
         /HWRmxZYN8SmlSK9ISlad89WgeCPWQHv4LNIM=
Date: Fri, 7 May 2010 14:11:36 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Steve French <smfrench@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: Sparse warning: "initializer entry defined twice"
Message-ID: <20100507061136.GC5921@cr0.nay.redhat.com>
References: <l2v524f69651005061643vcdc9f7c1h780344e30c123646@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <l2v524f69651005061643vcdc9f7c1h780344e30c123646@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 06, 2010 at 06:43:10PM -0500, Steve French wrote:
>Sparse, but not gcc, throws a warning ("make modules C=1") as follows
>on the first two lines of the following array of booleans
>
>  CHECK   fs/smb2/misc.c
>fs/smb2/misc.c:456:23: warning: Initializer entry defined twice
>fs/smb2/misc.c:457:27:   also defined here
>
>
>static const bool has_smb2_data_area[NUMBER_OF_SMB2_COMMANDS] = {
>    /* SMB2_NEGOTIATE */ true,
>    /* SMB2_SESSION_SETUP */ true,
>    /* SMB2_LOGOFF */ false,
>    /* SMB2_TREE_CONNECT */    false,
>    /* SMB2_TREE_DISCONNECT */ false,
>    /* SMB2_CREATE */ true,
>    /* SMB2_CLOSE */ false,
>    /* SMB2_FLUSH */ false,
>    /* SMB2_READ */    true,
>    /* SMB2_WRITE */ false,
>    /* SMB2_LOCK */    false,
>    /* SMB2_IOCTL */ true,
>    /* SMB2_CANCEL */ false, /* BB CHECK this not listed in documentation */
>    /* SMB2_ECHO */ false,
>    /* SMB2_QUERY_DIRECTORY */ true,
>    /* SMB2_CHANGE_NOTIFY */ true,
>    /* SMB2_QUERY_INFO */ true,
>    /* SMB2_SET_INFO */ false,
>    /* SMB2_OPLOCK_BREAK */ false
>};
>
>
>Any idea why sparse is complaining about the first two lines of the
>arry of booleans? Is this just a sparse bug?
>

Hmm, looks weird, sparse doesn't understand bool well?

Can you construct a small C program to show this? Something like:

typedef _Bool bool;
enum {
     false = 0,
     true = 1
};

static const bool foo[10] = {
       true,
       true,
       false,
       false,
};
