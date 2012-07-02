Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814Ab2GBI7Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 04:59:24 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36271 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932675Ab2GBI7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 04:59:23 -0400
Date: Mon, 2 Jul 2012 09:59:11 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Fernando Guzman Lugo <fernando.lugo@ti.com>
Subject: Re: [PATCH 2/2] remoteproc: remove the now-redundant kref
Message-ID: <20120702085911.GA16639@n2100.arm.linux.org.uk>
References: <1338017791-9442-1-git-send-email-ohad@wizery.com> <1338017791-9442-2-git-send-email-ohad@wizery.com> <4FC5DD74.4030202@codeaurora.org> <CAK=WgbbwaMAnTGcivC9ZR8K-MtTqHAV3+BgUmk8WjCaayifJxw@mail.gmail.com> <4FCD272E.1020300@codeaurora.org> <CAK=WgbZu1hYOd27r259b2v48VFYeOZ4UE5sD2awZDxgBgjAsXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK=WgbZu1hYOd27r259b2v48VFYeOZ4UE5sD2awZDxgBgjAsXw@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2012 at 11:52:27AM +0300, Ohad Ben-Cohen wrote:
> Simplify the unregister/free interfaces, and make them easier
> to understand and use, by moving to a symmetric and consistent
> alloc() -> register() -> unregister() -> free() flow.

The naming in the driver model is:

alloc() -> add() -> del() -> put()

where alloc() is an allocation + initialization, and

register() -> unregister()

where register() is initialization + add() and
unregister() is del() + put().
