Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684Ab1HNE2i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 00:28:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53285 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750727Ab1HNE2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 00:28:37 -0400
Date: Sun, 14 Aug 2011 13:28:28 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: soc-core: Fix checking return value of
 debugfs_create_dir
Message-ID: <20110814042826.GC20423@opensource.wolfsonmicro.com>
References: <1313292193.4421.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313292193.4421.1.camel@phoenix>
X-Cookie: You will forget that you ever knew me.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 14, 2011 at 11:23:13AM +0800, Axel Lin wrote:
> We have CONFIG_DEBUG_FS guard around the place calling debugfs_create_dir,
> thus debugfs_create_dir returns NULL on failure.

On the other hand the existing code doesn't actually have any problem,
the IS_ERR() won't give false positives, so the changelog isn't really
accurate and if anything we'll introduce a bug if someone cut'n'pastes
the code elsewhere.
