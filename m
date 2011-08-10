Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab1HJJ7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 05:59:53 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48912 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab1HJJ7w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 05:59:52 -0400
MIME-Version: 1.0
In-Reply-To: <20110810090014.GB1909@minipsycho.brq.redhat.com>
References: <CAMvAeqOA0=FnjB2oPPCEYpkXdKrmqOs+MwAqszV5sTGys_a3mQ@mail.gmail.com>
	<20110810090014.GB1909@minipsycho.brq.redhat.com>
Date: Wed, 10 Aug 2011 11:59:50 +0200
Message-ID: <CAMvAeqO2bLaPwmdW+c+7hz-ec=-tF6Z0EFBv=FA7+rU_QZ_wDA@mail.gmail.com>
Subject: Re: BUG: Bisected Gianfar in bridge not forwarding packets (was:
 3.0-rc1 Bridge not forwarding unicast packages)
From: Michael Guntsche <mguntsche@gmail.com>
To: Jiri Pirko <jpirko@redhat.com>
Cc: shemminger@vyatta.com, sebastian.belden@googlemail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 11:00 AM, Jiri Pirko <jpirko@redhat.com> wrote:
> Wed, Aug 10, 2011 at 02:50:20AM CEST, mguntsche@gmail.com wrote:
>>Good evening/morning,
>>
>>> I just upgraded my router/bridge combo to 3.1-rc1 from 3.0 for
>>> testing. On a first look everything seemed to work fine, but when I
>>> tried to connect via openvpn to my internal network (tap0 being bridged
>>> with the internal network) I noticed that I was not able to access the
>>> server on my internal network. I could access the bridge (which is
>>> acting as the openvpn server as well) just fine though.
>>> To debug this I ran tcpdump on the openvpn client and started a ping to the
>>> internal network. I could see the ARP requests being answered.....
>><snip>
>>
>>After much digging and testing I found the commit that causes the
>>problem for me here.
>>
>>87c288c6e gianfar: do vlan cleanup
>>
>>Before this commit my bridge works fine. I simplified the test case
>>and just tried to access the server from a local wireless device with
>>gets also bridged via
>>a gianfar nic to the wired lan. Before commit 87c288c6e I can ping the
>>device from the internal network afterwards it stops.
>>For testing purposes I reverted this commit (plus some others to make
>>the code compile) and it started working again.
>>The hardware is a routerboard with three onboard nics two of em gianfar.
>>The gianfar nics do not support any kind of offloading,
>>
>>Offload parameters for lan_wire:
>>rx-checksumming: off
>>tx-checksumming: off
>>scatter-gather: off
>>tcp-segmentation-offload: off
>>udp-fragmentation-offload: off
>>generic-segmentation-offload: off
>>generic-receive-offload: on
>>large-receive-offload: off
>>rx-vlan-offload: off
>>tx-vlan-offload: off
>>ntuple-filters: off
>>receive-hashing: off
>>
>>The Bridge device on the other hand....
>>
>>Offload parameters for lan:
>>rx-checksumming: on
>>tx-checksumming: on
>>scatter-gather: off
>>tcp-segmentation-offload: off
>>udp-fragmentation-offload: off
>>generic-segmentation-offload: off
>>generic-receive-offload: on
>>large-receive-offload: off
>>rx-vlan-offload: off
>>tx-vlan-offload: on
>  ^^^^^^^^^^^^^^^^^^^ is this gfar?
No the "Lan" nic is the bridge itself. The gfar in question is lan_wire.

/Michael
