Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab2KLPUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 10:20:24 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38200 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537Ab2KLPUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 10:20:21 -0500
MIME-Version: 1.0
In-Reply-To: <1352732343-1199-1-git-send-email-per.forlin@stericsson.com>
References: <1352732343-1199-1-git-send-email-per.forlin@stericsson.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 12 Nov 2012 15:20:00 +0000
X-Google-Sender-Auth: 0wp9YbufdBsuk_Ntv2_ttjTH3Z8
Message-ID: <CACxGe6vjLA3j-bc_048UrdB5Q=8pV8=LPSVUnU_k3anX23vwyw@mail.gmail.com>
Subject: Re: [PATCH] dt: platform: Extract device name from device tree blob
To: Per Forlin <per.forlin@stericsson.com>
Cc: rob.herring@calxeda.com, Linus Walleij <linus.walleij@linaro.org>,
        lee.jones@linaro.org, fredrik.soderstedt@stericsson.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 2:59 PM, Per Forlin <per.forlin@stericsson.com> wrote:
> Add support to extract device name from device tree blob.
> If the property "dev-name" is set in the DTS this name will
> be used when creating the device.
> The auxdata_lookup has precedence and will override
> the "dev-name" property.

Using a 'dev-name' property has the same problem that the 'cell-index'
properties have in that it is encoding part of the global namespace
local to the node and it becomes easy to create collisions. Instead of
this check to see if one of the properties in /aliases points to the
node and use that for the name.

g.
