Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab0LPNtP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 08:49:15 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51792 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670Ab0LPNtO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 08:49:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:references:in-reply-to:cc
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=ilTJ1ay+0yOCLvo7HKhtE0YmKfjGr8Dd35FrXRqsGPgYuylrDXYehY45y/ST6Z44lJ
         kKjNapaGkVl+Zv4sxCycCiPa6GF+QHQmsE/FdEE6T3TWBZpaBhT5vIPt7vlyiWd/hszz
         MNkQAgWQcQ2sHpyCruV53jbRdCCFUW190EGP4=
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: Reiserfs deadlock in  2.6.36
Date: Thu, 16 Dec 2010 14:49:48 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36; KDE/4.4.5; x86_64; ; )
References: <201011181650.00152.roucaries.bastien@gmail.com> <201011261757.08303.roucaries.bastien@gmail.com> <20101202174328.GA1750@nowhere>
In-Reply-To: <20101202174328.GA1750@nowhere>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201012161449.52318.roucaries.bastien@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 2 décembre 2010 18:43:32, vous avez écrit :
> On Fri, Nov 26, 2010 at 05:57:05PM +0100, Bastien ROUCARIES wrote:
> > Dear frederic,

Sorry for the delay was away internet during my hollidays
 
> > > Hi Bastien,
> > Nov 26 16:27:56 portablebastien kernel: [27960.811646] 
> > [<ffffffff8110142b>] sys_open+0x1b/0x1d Nov 26 16:27:56 portablebastien
> > kernel: [27960.813506]  [<ffffffff81009ac2>]
> > system_call_fastpath+0x16/0x1b
> 
> Ok, this time I don't have the feeling that a deadlock between reiserfs
> lock and another lock is involved.
> 
> We entered queue_log_writer() and then waited for someone to call
> do_journal_end() to testify he finished his job with the journal.
> 
> But somehow that didn't happen. Or may be we called queue_log_writer() but
> we shouldn't, thinking there was a writer already but there wasn't. Or
> there is a crazy race somewhere.
> 
> On which kernel do you see this? 
2.6.36
> Do you know a kernel on which you've never
> seen it. 
2.6.34 

> Were you running something specific to trigger this deadlock?
> 

Nothing specific but it is trigger by kmail reading my mail each time...

Bastien
> Thanks!
