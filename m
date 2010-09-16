Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab0IPMkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 08:40:11 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:52746 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab0IPMkJ convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:4:1>);
	Thu, 16 Sep 2010 08:40:09 -0400
Message-Id: <4C922C700200007800016CB4@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 16 Sep 2010 13:40:48 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <eric@anholt.net>
Cc: <Brice.Goglin@ens-lyon.org>, <airlied@linux.ie>,
        <linux-kernel@vger.kernel.org>
Subject: Re: agp/intel: Fix the pre-9xx chipset flush
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric,

in this patch you removed from intel_i830_setup_flush() a call to
map_page_into_agp(), but you left in place the counterpart call from
intel_i830_fini_flush() to unmap_page_from_agp()? Isn't it mere luck
that on x86 this is only a call to set_pages_wb()?

Further, is there really a point in doing the respective allocation
with GFP_DMA32? Nor does __GFP_ZERO seem really necessary...

Thanks, Jan

