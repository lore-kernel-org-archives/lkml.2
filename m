Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab0KYNxo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 08:53:44 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49844 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752172Ab0KYNxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 08:53:42 -0500
Date: Thu, 25 Nov 2010 13:53:51 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, lrg@slimlogic.co.uk,
        sakari.ailus@maxwell.research.nokia.com, lennart@poettering.net
Subject: Re: [RFC/PATCH v6 09/12] media: Entity locking and pipeline
 management
Message-ID: <20101125135351.GD24208@opensource.wolfsonmicro.com>
References: <1290652099-15102-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1290652099-15102-10-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290652099-15102-10-git-send-email-laurent.pinchart@ideasonboard.com>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 03:28:16AM +0100, Laurent Pinchart wrote:
> Link states must not be modified while streaming is in progress on a
> graph they belong or connect to. The entity locking API helps drivers
> enforcing that requirement.

This is not desirable for embedded audio - for example, it is very
common to wish to switch from headphone to speaker and back mid
playback, or to move between headset, speakerphone and handset modes on
a phone.  This is normally implemented by reconfiguring the output paths
at runtime without interrupting applications.
