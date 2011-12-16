Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759460Ab1LPNrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 08:47:00 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:54042 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756519Ab1LPNqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 08:46:53 -0500
X-Sasl-enc: VSwoLdUREysVHE1TysZOPdWDeYjZTwAXCc3iX7xO+gzg 1324043212
Message-ID: <4EEB4C51.4010205@ladisch.de>
Date: Fri, 16 Dec 2011 14:49:05 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: "Richard W.M. Jones" <rjones@redhat.com>
CC: alsa-devel@alsa-project.org, Tom Walder <tom.walder@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH] Jabra SPEAK 410 USB - no audio playback
References: <20111210142419.GC16692@amd.home.annexia.org> <20111210194539.GF16692@amd.home.annexia.org>
In-Reply-To: <20111210194539.GF16692@amd.home.annexia.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard W.M. Jones wrote:
> The attached patch fixes USB audio support for the Jabra SPEAK 410 USB.
>
> The problem, as I understand it, is that the device contains a
> Class-Specific Endpoint (CS_ENDPOINT) descriptor before the Endpoint
> (ENDPOINT) descriptor.  The USB code all assumes that CS_ENDPOINT can
> only appear after ENDPOINT.  Therefore the USB code divides up the
> interface descriptor into "stuff before ENDPOINT" (in
> interface->extra) and "stuff after ENDPOINT" (in
> interface->endpoint[0]->extra).  For this device, this division does
> not work.
>
> The solution (which is a hack ...) is to also search interface->extra
> looking for the missing descriptor.

The patch looks good.  Please run it through checkpatch.pl and provice
a Signed-off-by tag (see Documentation/SubmittingPatches).


Regards,
Clemens
