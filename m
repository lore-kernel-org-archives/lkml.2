Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab2HMVE5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 17:04:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54537 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880Ab2HMVE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 17:04:56 -0400
Date: Mon, 13 Aug 2012 16:04:44 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        Bernhard Froemel <froemel@vmars.tuwien.ac.at>
Subject: Re: [PATCH 2/2] apple_gmux: Add support for newer hardware
Message-ID: <20120813210444.GJ24088@thinkpad-t410>
Mail-Followup-To: Matthew Garrett <mjg@redhat.com>,
	linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
	Bernhard Froemel <froemel@vmars.tuwien.ac.at>
References: <1344889232-3907-1-git-send-email-mjg@redhat.com>
 <1344889232-3907-2-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344889232-3907-2-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 04:20:32PM -0400, Matthew Garrett wrote:
> +static int gmux_index_wait_ready(struct apple_gmux_data *gmux_data)
> +{
> +	int i = 200;
> +	u8 gwr = inb(gmux_data->iostart + GMUX_PORT_WRITE);
> +
> +	while (i && (gwr & 0x01)) {
> +		inb(gmux_data->iostart + GMUX_PORT_READ);
> +		gwr = inb(gmux_data->iostart + GMUX_PORT_WRITE);
> +		msleep(100);

Wouldn't it make more sense if the msleep was before reading the port
again? Otherwise there's no substantial dely between the first and
second times we read it.

> +static int gmux_index_wait_complete(struct apple_gmux_data *gmux_data)
> +{
> +	int i = 200;
> +	u8 gwr = inb(gmux_data->iostart + GMUX_PORT_WRITE);
> +
> +	while (i && (gwr & 0x01)) {
> +		gwr = inb(gmux_data->iostart + GMUX_PORT_WRITE);
> +		msleep(100);

Likewise.

