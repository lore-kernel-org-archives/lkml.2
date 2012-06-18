Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab2FRULo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 16:11:44 -0400
Received: from mx2.netapp.com ([216.240.18.37]:21751 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464Ab2FRULn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 16:11:43 -0400
X-IronPort-AV: E=Sophos;i="4.75,793,1330934400"; 
   d="scan'208";a="656270079"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Ken Moffat <zarniwhoop@ntlworld.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: nfs3 problem with -rc{2,3}
Thread-Topic: nfs3 problem with -rc{2,3}
Thread-Index: AQHNTMS9i2iatMLpKEGb4f4ZWuxoUpcAjD8AgAAA1ACAAAlRAIAACccAgAASfoCAAESLgIAAAb6A
Date: Mon, 18 Jun 2012 20:11:40 +0000
Message-ID: <1340050299.20570.4.camel@lade.trondhjem.org>
References: <20120617200700.GA15348@milliways>
	 <1340026956.2451.9.camel@lade.trondhjem.org>
	 <1340027134.2451.12.camel@lade.trondhjem.org>
	 <20120618141854.GA7962@milliways>
	 <1340031234.2451.13.camel@lade.trondhjem.org>
	 <20120618160005.GA10169@milliways> <20120618200525.GA15654@milliways>
In-Reply-To: <20120618200525.GA15654@milliways>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <931386E93BB328479DCDBA465CCE6364@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5IKBshG023779

On Mon, 2012-06-18 at 21:05 +0100, Ken Moffat wrote:
> On Mon, Jun 18, 2012 at 05:00:05PM +0100, Ken Moffat wrote:
> > > 
> > > OK. You said you had bisected this down to 15 patches? Can you please
> > > tell me which ones?
> > > 
> > 
> >  I'm just about to resume, to see if I can get anywhere - the rc2
> > version built fine, so I'm guessing that some more of the remaining
> > versions will also build.  Not sure which commits are still
> > outstanding.
> > 
> 
>  Turned out that almost everything from 3e9e0ca3 failed to compile,
> until 4f97615d (fix for NFS_V4_1 undefined) resolved that, (only had
> one or two still to try when I decided to use 'git visualize').  And
> it was bad by 4f97615d.
> 
>  Added all the NFS v4 / 4.1 client options to my config :
> 3e9e0ca3 is now good, I'll start a fresh bisect between these two.
> 
>  Actually, I'd better retry 4f97515d to confirm it is still bad with
> this config. [ saves this message, tests ... ].  Rude words!  If I
> enable all the NFS v4 client options, 4f97615d is good.
> 
>  Looks, to me, as if something in that untested range of patches, or
> in 3e9e0ca3 itself, causes the problem *if* nfs v4 is not enabled.

OK. That's helpful... I've been compiling a kernel without CONFIG_NFS_V4
enabled, and have run a few tests using fsx. So far, I haven't managed
to reproduce your issue.

The next time that you see the hang, can you try to run the command
'echo "t" >/proc/sysrq-trigger' as root?
If you can compile with CONFIG_SUNRPC_DEBUG, then an 'echo 0
>/proc/sys/rpc_debug' might also be helpful.

Cheers
  Trond

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
