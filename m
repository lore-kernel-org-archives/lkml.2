Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab1CHOSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 09:18:55 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49347 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469Ab1CHOSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 09:18:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=j36xa7zglw6W6wYCSvhz//ZTpMnn3IM2ql6cOemxwOeawBVS6FBUVaHDAL7UvmcJgH
         QZeHtiCcw9BcYJ8FqyoT7F05Y/ZeEhRMbb2nR43zI0wxO2FsGt221Q42EpaGlCm6A61u
         jnk16YH5CoTqOoujUhg8XrjslRPbYWtpYbGKA=
Date: Tue, 8 Mar 2011 15:18:49 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Bastien ROUCARIES <roucaries.bastien@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Reiserfs deadlock in 2.6.36
Message-ID: <20110308141847.GB1837@nowhere>
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
> 
> Bastien

You have a first series of hung task report from 19440.852298 to 19440.880024
then it's followed by the traces and then again with a hung task report at
19560.880084. But there is only one task stuck in that 2nd report. Did
you report your whole dmesg there or have you cut it? If it's your
whole dmesg then it means the other tasks from the first report have released
from their hung state. So the queued writers have been released by someone
who closed the journal.

This could confirm the theory that someone has opened the journal and
spent way too much time before releasing it. Or something else.
In any case tell me, there are other tests we can run.
