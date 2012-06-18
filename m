Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab2FRUFa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 16:05:30 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:44598 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751265Ab2FRUF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 16:05:29 -0400
Date: Mon, 18 Jun 2012 21:05:25 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: nfs3 problem with -rc{2,3}
Message-ID: <20120618200525.GA15654@milliways>
References: <20120617200700.GA15348@milliways>
 <1340026956.2451.9.camel@lade.trondhjem.org>
 <1340027134.2451.12.camel@lade.trondhjem.org>
 <20120618141854.GA7962@milliways>
 <1340031234.2451.13.camel@lade.trondhjem.org>
 <20120618160005.GA10169@milliways>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120618160005.GA10169@milliways>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Cloudmark-Analysis: v=1.1 cv=JvdXmxIgLJv2/GthKqHpGJEEHukvLcvELVXUanXFreg= c=1 sm=0 a=wom5GMh1gUkA:10 a=IxJ0d4kOqokA:10 a=uObrxnre4hsA:10 a=IkcTkHD0fZMA:10 a=MAu2br0noMOb-L-UWAYA:9 a=QEXdDO2ut3YA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 05:00:05PM +0100, Ken Moffat wrote:
> > 
> > OK. You said you had bisected this down to 15 patches? Can you please
> > tell me which ones?
> > 
> 
>  I'm just about to resume, to see if I can get anywhere - the rc2
> version built fine, so I'm guessing that some more of the remaining
> versions will also build.  Not sure which commits are still
> outstanding.
> 

 Turned out that almost everything from 3e9e0ca3 failed to compile,
until 4f97615d (fix for NFS_V4_1 undefined) resolved that, (only had
one or two still to try when I decided to use 'git visualize').  And
it was bad by 4f97615d.

 Added all the NFS v4 / 4.1 client options to my config :
3e9e0ca3 is now good, I'll start a fresh bisect between these two.

 Actually, I'd better retry 4f97515d to confirm it is still bad with
this config. [ saves this message, tests ... ].  Rude words!  If I
enable all the NFS v4 client options, 4f97615d is good.

 Looks, to me, as if something in that untested range of patches, or
in 3e9e0ca3 itself, causes the problem *if* nfs v4 is not enabled.

 I suppose I'll have to enable v4 in my configs.

ĸen
-- 
das eine Mal als Tragödie, das andere Mal als Farce
