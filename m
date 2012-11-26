Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab2KZXkB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 18:40:01 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:45394 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796Ab2KZXkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 18:40:00 -0500
Message-ID: <50B3FDCC.7080709@wwwdotorg.org>
Date: Mon, 26 Nov 2012 16:39:56 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Terje Bergstrom <tbergstrom@nvidia.com>
CC: thierry.reding@avionic-design.de, linux-tegra@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [RFC v2 5/8] ARM: tegra: Add auxiliary data for nvhost
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com> <1353935954-13763-6-git-send-email-tbergstrom@nvidia.com>
In-Reply-To: <1353935954-13763-6-git-send-email-tbergstrom@nvidia.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2012 06:19 AM, Terje Bergstrom wrote:
> Add SoC specific auxiliary data to host1x and gr2d. nvhost uses
> this data.
> 
> Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com>
> Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>

Arto's S-o-b really should be first and yours last since you're (Terje)
the one who touched the patches last.

> diff --git a/arch/arm/mach-tegra/board-dt-tegra20.c b/arch/arm/mach-tegra/board-dt-tegra20.c

I think none of the changes the board-dt-tegra*.c should be made.

AUXDATA is a temporary measure to keep things working during the
transition to device tree. We want to remove entries from the AUXDATA
tables rather than add them. The only thing that's stopping us from
doing so right now is the lack of DT-based clock lookups, which hence
require devices to have a specific name.

> +static struct nvhost_device_data tegra_host1x_info = {
> +	.clocks = { {"host1x", UINT_MAX} },

> +static struct nvhost_device_data tegra_gr2d_info = {
> +	.clocks		= { {"gr2d", UINT_MAX, true}, {"epp", UINT_MAX, true} },

Clock names shouldn't be passed in platform data; instead, clk_get()
should be passed the device object and device-relative (i.e. not global)
clock name. I expect if the driver is fixed to make this change, the
changes to tegra*_clocks_data.c won't be needed either.

