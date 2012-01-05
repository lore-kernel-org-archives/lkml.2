Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945Ab2AEF7E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 00:59:04 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54860 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751377Ab2AEF7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 00:59:02 -0500
Date: Thu, 5 Jan 2012 05:59:00 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan.com@nvidia.com>
Cc: lrg@slimlogic.co.uk, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        ldewangan@nvidia.com
Subject: Re: [PATCH V1] regulator: fixed: Move drivers to
	subsys_initcall_sync()
Message-ID: <20120105055900.GE11867@opensource.wolfsonmicro.com>
References: <1325693335-1905-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325693335-1905-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 04, 2012 at 09:38:55PM +0530, Laxman Dewangan wrote:
> From: Laxman Dewangan <ldewangan@nvidia.com>
> 
> The fixed regulator is used to enable/disable rails which are
> mainly controlled by the switch. The switches are toggled by
> gpio apis.
> The switches are connected through on-chip gpios or through
> external devices' gpios like mfd, i2c based gpio expander etc.
> The registration of the fixed regulator get success only if the
> required gpios are already available in the system at this time.
> The on-chip gpios are available till this time as on-chip gpios
> are initialized in arch_init(). But external peripheral's gpios
> may not be available at this time as they get initialized as part
> of subsys_initcall() and due to this registration of the fixed
> regulator may fails.
> Moving the driver to subsys_initcall_sync() will make sure that
> all gpios i.e. on-chip gpios as well as external peripheral's gpios
> are available before fixed regulator registration.

I don't really think this is worth faffing about with, it seems at least
as likely to create more problems with things that depend on the
regulator as it is to make the regulator work.  Really we need Grant's
probe retry stuff or something else to solve the init ordering issues
properly.
