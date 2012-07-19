Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab2GSSnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 14:43:21 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:54616 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab2GSSnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 14:43:16 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjNBACpUCFBV5qoUPGdsb2JhbABFhQ6FGq8aGQEBAQE3NIIgAQEEATocIwULCANGFCUKGogaCr5VFJFoYAOVQ4VpjQI
X-IronPort-AV: E=Sophos;i="4.77,617,1336341600"; 
   d="scan'208";a="83100848"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 19 Jul 2012 20:44:19 +0200
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>,
        =?utf-8?B?IkNodW5nLVlpaCBXYW5nICjnjovltIfmh78pIg==?= 
	<cywang@google.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        JJ Ding <dgdunix@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Input: synaptics - use firmware data for Cr-48
Message-ID: <20120719184419.GA3626@polaris.bitmath.org>
References: <1342606923-9997-1-git-send-email-cywang@chromium.org>
 <5006D86C.7030208@canonical.com>
 <CAM2ehZbftDja6CBGjhL3Jp+30DtYJj+8_4e=_wWcj3pCDGD7AA@mail.gmail.com>
 <500832D7.4040805@canonical.com>
 <CAGS+omA-PwoM=U3xP_Gtadaow9SGt555NPWor_-HuvVE8-R3MQ@mail.gmail.com>
 <50084529.2030001@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50084529.2030001@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I understand the usefulness of this functionality, but I also worry
> about proliferating the number of properties for devices (there are
> only 32 bits we can use, IIRC). I see four options off the top of my
> head:
> 
> * Don't do anything, leave it as SEMI_MT. Obviously this would suck,
> but it is an option.
> 
> * Make the trackpad advertise itself as *not* SEMI_MT. This would be
> broken, however, if the user performs a rotation where the touches
> cross in the Y axis. I feel this is plain wrong according to the
> stated protocol documentation and previous behavior, so I don't want
> to do this.
> 
> * Add a new device property (INVALID_Y_AXIS_CROSSING?) that
> describes the exact behavior of this device. I would be ok with this
> if everyone else is, but only because proper clickpad behavior
> (which I consider very importand) is broken without this knowledge.
> 
> * Leave the device as SEMI_MT, but provide the real locations, and
> allow userspace to determine the device vendor/model/etc. If
> userspace knows that a specific device behaves in a specific way, it
> can do its own quirking handling. Given the specificity of this
> behavior to only some devices of one brand, this would be my
> suggested resolution to the issue.

A fifth option is to quirk the driver to remove the pulling effect
from the reported bounding box, such that the simple userspace scheme
for determining the position of the moving finger actually works.

For instance, consider the simple algorithm "the slowest corner is the
stationary finger". As long as this is true, the behavior will be
smooth. If the sensor data clutters this behavior, it shows up in the
driver as a mismatch between the point as computed above and the
better estimate available in the driver. For frames where this
happens, one can simply alter the bounding box slightly so that the
algorithm works.

It should be possible to formulate such a scheme in a couple of lines.

Henrik
