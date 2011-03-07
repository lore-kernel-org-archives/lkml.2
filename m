Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab1CGTAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 14:00:51 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39251 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab1CGTAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 14:00:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=XRZcDvxJR73bAUn9XQ5ZZFVPZ9mSvhpSme3ay6aBLj+e4iV8h/9Qr8eyl8/Uy8X8Wq
         D0TUHKDDA72N6LGwLUzvgsA/VOCAMUDfTQT3ccxiAACEDkiY5wW0/pdiJP/3Z1T3fdfJ
         f820zC1GED2sgAKDXwxf6GB6XMcYRDjQjo5RM=
Date: Mon, 7 Mar 2011 20:00:45 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Bastien ROUCARIES <roucaries.bastien@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Reiserfs deadlock in 2.6.36
Message-ID: <20110307190040.GI1873@nowhere>
References: <201011181650.00152.roucaries.bastien@gmail.com>
 <AANLkTik=+smaiGNwVw0pDBXexVd=trsz9aSawuqLZP6k@mail.gmail.com>
 <20101223034229.GF1739@nowhere>
 <201101300108.32383.roucaries.bastien@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201101300108.32383.roucaries.bastien@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bastien,

Sorry for the time I've been away.

On Sun, Jan 30, 2011 at 01:08:29AM +0100, Bastien ROUCARIES wrote:
> Le jeudi 23 décembre 2010 04:42:33, Frederic Weisbecker a écrit :
> Hi,
> 
> I take me more than two days of testing to reporduce this bugs with trace enabled. My filesystem was quite slow and this bugs seems 
> to be timing related.
> 
> One patern that trigger this bug is git. Doing a lot of git work of my desktop crash my machine.
> 
> Moreover, trying to reproduce this bug lead to data loss. I have rebuilded twice my / partition using --rebuild-tree, and restored 
> my home partition three times using backups.
> 
> My log is here.
> 
> Do you need more information?

Yeah do you have CONFIG_REISERFS_CHECK? I just would
like to ensure we are not missing this important source of
information.

I'm puzzled because, given the traces, your opening and closing of the journal are
well balanced.

You have a writer queued and stuck but I see no trace of it in the traces stream.
I only see well balanced journal operations, including journal closing that would have
woken your queued writer.

A theory could be that your queued writer was waiting for someone to close the journal,
which finally happen but actually several minutes later, after there was many
journal opening/closing that overwrote the old trace containing the queueing of
the stuck writer.

I don't know what to do yet. I need to think more about it.
