Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626Ab0HXH5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 03:57:46 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:37027 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab0HXH5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 03:57:43 -0400
Date: Tue, 24 Aug 2010 08:57:41 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
Subject: Re: [REGRESSION, i915]: Periodic stalls with 2.6.36-rc2
Message-ID: <20100824075741.GA11000@sucs.org>
References: <20100823233551.GA31920@sucs.org> <89kc63$hrmse5@fmsmga002.fm.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89kc63$hrmse5@fmsmga002.fm.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 01:12:22AM +0100, Chris Wilson wrote:
> 
> From the error message, I'd suggest we'd tackle hangcheck - it simply
> shouldn't be firing at all under normal circumstances. (Looking at it we
> don't handle the introduction of the BSD ring correctly, but that is
> irrelevant on the EeePC 900.)
> 
> Do the stalls and tearing go away with:

The stalls became a bit better with the patch but there were still very
small pauses but the tearing with more recent X bits is definitely still
there. Additionally videos in totem would play as a tiny one pixel high
row about a quarter of the screen across at the top left of the screen.
It also seems that X has started having trouble refreshing itself so
sometimes new windows are invisible (especially with compiz).

I've also noticed a couple of other things. Sometimes (but without any
pattern) an extra display is detected even though no external display is
plugged in. Here's an example of the xrandr output:
Screen 0: minimum 320 x 200, current 2384 x 768, maximum 4096 x 4096
LVDS1 connected 1024x600+0+0 (normal left inverted right x axis y axis) 0mm x 0mm
   1024x600       59.5*+
   800x600        85.1     72.2     75.0     60.3     56.2  
   640x480        85.0     72.8     75.0     59.9  
   720x400        85.0  
   640x400        85.1  
   640x350        85.1  
VGA1 disconnected (normal left inverted right x axis y axis)
TV1 disconnected (normal left inverted right x axis y axis)
  1360x768 (0xbc)   84.8MHz
        h: width  1360 start 1432 end 1568 total 1776 skew    0 clock   47.7KHz
        v: height  768 start  771 end  781 total  798           clock   59.8Hz

Sometimes the output is TV1 sometimes it is VGA1 and sometimes these
extra outputs will disappear. Another issue is that switching from X to
a console for the first time causes a LCD "blooming" effect.

-- 
Sitsofe | http://sucs.org/~sits/
