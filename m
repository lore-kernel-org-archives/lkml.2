Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab1HZGIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 02:08:53 -0400
Received: from mail.vyatta.com ([76.74.103.46]:45666 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692Ab1HZGIv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 02:08:51 -0400
Date: Thu, 25 Aug 2011 23:08:59 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        =?utf-8?B?TWljaGHFgk1pcm9zxYJhdw==?= <mirq-linux@rere.qmqm.pl>,
        Tom Herbert <therbert@google.com>, Jesse Gross <jesse@nicira.com>,
        herbert@gondor.hengli.com.au, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH net-next ] Fix time-lag of IFF_RUNNING flag consistency
 between vlan and real devices
Message-ID: <20110825230859.11b2b132@nehalam.ftrdhcpuser.net>
In-Reply-To: <20110826060257.5304.62723.stgit@ltc219.sdl.hitachi.co.jp>
References: <20110826060257.5304.62723.stgit@ltc219.sdl.hitachi.co.jp>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Aug 2011 15:02:57 +0900
Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com> wrote:

> There is a time-lag of IFF_RUNNING flag consistency between vlan and real
> devices when the real devices are in problem such as link or cable broken.
> This leads to a degradation of Availability such as a delay of failover in
> HA systems using vlan since the detection of the problem at real device is
> delayed.
> 
> Why this happens:
> Network devices' flags can be checked using ioctl with SIOCGIFFLAGS. When
> vlan technique is used, it checks the flags of vlan device, not real
> device.
> 
> Patch:
> This patch adds vlan-device check into dev_get_flags(). So, it can check
> flags of the real device even if the vlan is used.
> 
> Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
> Cc: Patrick McHardy <kaber@trash.net>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: "Michał Mirosław" <mirq-linux@rere.qmqm.pl>
> Cc: Tom Herbert <therbert@google.com>
> Cc: Jesse Gross <jesse@nicira.com>

I don't think this is the right way to solve the problem.

The flags are supposed to propagate back from real device to vlan
via network notifications.

Just doing this for ioctl is not enough, API's other than user space depend on this.
Also the user may have manually set different flags on vlan than on
the real device.
