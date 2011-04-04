Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab1DDO4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 10:56:13 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63042 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669Ab1DDO4M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 10:56:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=sTkP461KYwn/nfm/B5UegWyPpKhKzNR2zMGyn/vkBs1fwdX5qOb/hNJN84+NsMAQrQ
         OdYnLcjFLpFdyfag3vAYeQNyRb/bxuFOwLeTPESjQ9ze5cBQ/99kyaG/SYX8IpPrsxTB
         GwStKJ842CYfvtOIqo6xBHY6aWq0QZKQhBEqs=
MIME-Version: 1.0
In-Reply-To: <131751.1301921295@localhost>
References: <BANLkTi=pS8Wk9Ymtj=DeVqfgqBsbTXDHZA@mail.gmail.com>
	<BANLkTi=Mu70wYSM0sVRWZnQzTPBOvqt6xg@mail.gmail.com>
	<131751.1301921295@localhost>
Date: Mon, 4 Apr 2011 22:56:11 +0800
Message-ID: <BANLkTikA8QXXCMPnigP6_cDJNpt2EWMagA@mail.gmail.com>
Subject: Re: [2.6.39-rc1] LTP hitting max (8) nested links...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Valdis.Kletnieks@vt.edu, Nick Piggin <npiggin@kernel.dk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 April 2011 20:48,  <Valdis.Kletnieks@vt.edu> wrote:
> On Mon, 04 Apr 2011 11:19:08 +0800, Daniel J Blueman said:
>
>> Re-reading everything, nested here is actually recursively nested, not
>> consecutively nested, so will never succeed, so we expect this from
>> the LTP test.
>
> We expect the LTP test to be handed an error, I suspect.  The LTP test
> probably shouldn't be able to provoke a BUG_ON.

In fact, since userspace does correctly return ELOOP [1], and I can't
reproduce it with 2.6.37, it does looks like a race in the RCU VFS
lookup, so adding Nick in the loop.

--- [1]

$ ln -s foo bar && ln -s bar foo
$ strace -e mkdir mkdir foo/a
mkdir("foo/a", 0777)                    = -1 ELOOP (Too many levels of
symbolic links)
mkdir: cannot create directory `foo/a': Too many levels of symbolic links
-- 
Daniel J Blueman
