Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab0DBUFe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 16:05:34 -0400
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:44393 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751286Ab0DBUF1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 16:05:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=nffY1vjrUJYn2PgVFV44j710/+sigEJdh3BYRN5LN2FcPYhMErYdmFLWwM2TiW1Hlw46+zBgIpUnq7Mxwh/aIMRLfIk2tqOn0ZyvbpIXD8fKxkhi4y8ECw/pViTzQcji;
Date: Fri, 2 Apr 2010 13:03:47 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Norbert Preining <preining@logic.at>
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: intel graphic card hanging (Hangcheck timer elapsed... GPU
 hung)
Message-ID: <20100402130347.4950c63e@jbarnes-piketon>
In-Reply-To: <20100330135706.GA27958@gamma.logic.tuwien.ac.at>
References: <20100327161104.GA12043@gamma.logic.tuwien.ac.at>
	<20100329093702.65a2f1f9@jbarnes-piketon>
	<20100330135706.GA27958@gamma.logic.tuwien.ac.at>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Mar 2010 22:57:06 +0900
Norbert Preining <preining@logic.at> wrote:

> On Mo, 29 Mär 2010, Jesse Barnes wrote:
> > I was seeing something similar on my 945, can you try this patchset?
> 
> Tried it with git kernel commit b72c409 and your patches, but
> didn't change anything. Starting d2x-xl killed the X server:
> [ 1067.920246] render error detected, EIR: 0x00000000
> [ 1067.920293] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request returns -5 (awaiting 48294 at 48216)
> [ 1068.412095] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
> [ 1068.412107] render error detected, EIR: 0x00000000
> [ 1068.412135] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request returns -5 (awaiting 48299 at 48216)
> [ 1068.776229] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
> 
> Anything else I could try?

One of my 945 machines became pretty stable after increasing the
hancheck timeout from 75 to 750 jiffies in i915_drv.h.  But I have
reports that it doesn't work on all machines, so it's probably just
covering up a bug somewhere else.

-- 
Jesse Barnes, Intel Open Source Technology Center
