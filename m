Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415Ab1IPWda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 18:33:30 -0400
Received: from claw.goop.org ([74.207.240.146]:43496 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755837Ab1IPWd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 18:33:28 -0400
Message-ID: <4E73CEB5.9090406@goop.org>
Date: Fri, 16 Sep 2011 15:33:25 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: padovan@profusion.mobi
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org,
        Keith Packard <keithp@keithp.com>
Subject: Re: Bluetooth regression with headphones
References: <4E6EB2DE.8090102@goop.org>
In-Reply-To: <4E6EB2DE.8090102@goop.org>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2011 06:33 PM, Jeremy Fitzhardinge wrote:
> Hi all,
>
> I reported a regression in connecting my Nokia BH-905i headphones in
> June this year (https://lkml.org/lkml/2011/6/23/770), which was the same
> problem Keith Packard reported in https://lkml.org/lkml/2011/6/9/63.  
> It was briefly fixed in
> git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git.
>
> Unfortunately it regressed again by the time of the linux-3.0 release,
> to something with similar symptoms: the headphones won't reliably
> connect to my laptop unless I freshly re-pair them.  However, unlike the
> original bug, they will very occasionally connect normally, though I
> don't know why.
>
> This behaviour has been consistent since 3.0 up until the current
> 3.1-rc6 kernel.
>
> What further information can I provide?  How can I help debug this?

I turned on debugging by running "bluetoothd -n -d", and got the
following when trying to connect my headphones:

Sep 16 15:30:47 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:headset_set_state() State changed /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D: HEADSET_STATE_DISCONNECTED -> HEADSET_STATE_CONNECTING
Sep 16 15:30:47 saboo bluetoothd[22025]: bluetoothd[22025]: src/adapter.c:adapter_get_device() 00:0B:E4:A6:6C:0D
Sep 16 15:30:47 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:remote_features_information() hci0 status 0
Sep 16 15:30:48 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:remote_name_information() hci0 status 0
Sep 16 15:30:48 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:headset_set_channel() Discovered Handsfree service on channel 1
Sep 16 15:30:48 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:rfcomm_connect() /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D: Connecting to 00:0B:E4:A6:6C:0D channel 1
Sep 16 15:30:48 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:link_key_request() hci0 dba 00:0B:E4:A6:6C:0D
Sep 16 15:30:48 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:link_key_request() kernel auth requirements = 0x04
Sep 16 15:30:48 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:link_key_request() Matching key found
Sep 16 15:30:48 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:link_key_request() link key type 0x04
Sep 16 15:30:48 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:auth_complete() hci0 status 0
Sep 16 15:30:48 saboo bluetoothd[22025]: bluetoothd[22025]: src/event.c:btd_event_bonding_process_complete() status=00
Sep 16 15:30:48 saboo bluetoothd[22025]: bluetoothd[22025]: src/adapter.c:adapter_get_device() 00:0B:E4:A6:6C:0D
Sep 16 15:30:48 saboo bluetoothd[22025]: bluetoothd[22025]: src/event.c:btd_event_bonding_process_complete() no pending auth request
Sep 16 15:30:50 saboo bluetoothd[22025]: bluetoothd[22025]: Permission denied (13)
Sep 16 15:30:50 saboo bluetoothd[22025]: Permission denied (13)
Sep 16 15:30:50 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:headset_set_state() State changed /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D: HEADSET_STATE_CONNECTING -> HEADSET_STATE_DISCONNECTED
Sep 16 15:30:50 saboo bluetoothd[22025]: bluetoothd[22025]: src/adapter.c:adapter_get_device() 00:0B:E4:A6:6C:0D


Does this cast any light on what's going wrong?

Thanks,
    J
