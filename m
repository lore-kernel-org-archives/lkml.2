Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758826Ab0DAR7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 13:59:51 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:58985 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758705Ab0DAR7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 13:59:45 -0400
Date: Thu, 1 Apr 2010 12:59:38 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: linux-kernel@vger.kernel.org
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       linux-mm@kvack.org
Subject: Re: 2.6.34-rc3, BUG at mm/slab.c:2989
In-Reply-To: <20100401175225.GA6581@fancy-poultry.org>
Message-ID: <alpine.DEB.2.00.1004011257470.17168@router.home>
References: <20100401175225.GA6581@fancy-poultry.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Apr 2010, Heinz Diehl wrote:

> Apr  1 18:20:33 liesel kernel: kernel BUG at mm/slab.c:2989!

Typical for slab metadata corruption. You need to run with debugging on.

Switch to SLUB and set SLUB_DEBUG_ON. Reboot and reproduce situation.
Check the syslog after while. SLUB will repair the situation and continue
if possible. There may not be failure.

