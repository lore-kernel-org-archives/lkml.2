Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118Ab1G3PEZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 11:04:25 -0400
Received: from mout2.freenet.de ([195.4.92.92]:37684 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572Ab1G3PES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 11:04:18 -0400
Message-ID: <4E341DC4.9010107@01019freenet.de>
Date: Sat, 30 Jul 2011 17:05:40 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110720 Firefox/5.0 SeaMonkey/2.2
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: Stanislaw Gruszka <sgruszka@redhat.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ivo van Doorn <IvDoorn@gmail.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, Alan Piszcz <ap@solarrain.com>,
        "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [PATCH] rt2x00: rt2800: fix zeroing skb structure
References: <alpine.DEB.2.02.1107271851410.25432@p34.internal.lan> <4E318BD0.40202@lwfinger.net> <20110730113009.GA2847@redhat.com> <20110730113255.GB2847@redhat.com> <alpine.DEB.2.02.1107300736010.4925@p34.internal.lan> <alpine.DEB.2.02.1107301015340.4925@p34.internal.lan> <alpine.DEB.2.02.1107301031560.4925@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.02.1107301031560.4925@p34.internal.lan>
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Justin,

if you want to test, if the module works stable, run this script for one
or two hours. It will stress the driver and the hardware.

If it doesn't crash and if the throughput is stable, you can hope, that
the driver is ok for daily work.


#!/bin/sh

dest="server" # set the servername

while true ; do
netperf -t TCP_MAERTS -H $dest
netperf -t TCP_STREAM -H $dest
netperf -t TCP_SENDFILE -H $dest
done


Start the script on the client. On the server start netserver.
You get netperf from http://www.netperf.org/netperf/


Andreas
