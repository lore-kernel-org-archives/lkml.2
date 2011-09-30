Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab1I3Ewi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 00:52:38 -0400
Received: from claw.goop.org ([74.207.240.146]:43865 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283Ab1I3Ewf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 00:52:35 -0400
Message-ID: <4E854B0E.6090809@goop.org>
Date: Thu, 29 Sep 2011 21:52:30 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org,
        Keith Packard <keithp@keithp.com>,
        Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Ilia Kolomisnky <ilia.kolominsky@gmail.com>
Subject: Re: Bluetooth regression with headphones
References: <4E6EB2DE.8090102@goop.org> <4E73CEB5.9090406@goop.org> <4E73CFEF.5000509@goop.org> <4E84AF39.7090205@goop.org> <20110929200122.GF2605@joana>
In-Reply-To: <20110929200122.GF2605@joana>
X-Enigmail-Version: 1.3.2
Content-Type: multipart/mixed;
 boundary="------------000703080002070601080608"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000703080002070601080608
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 09/29/2011 01:01 PM, Gustavo Padovan wrote:
> Hi Jeremy,
>
> * Jeremy Fitzhardinge <jeremy@goop.org> [2011-09-29 10:47:37 -0700]:
>
>> On 09/16/2011 03:38 PM, Jeremy Fitzhardinge wrote:
>>> On 09/16/2011 03:33 PM, Jeremy Fitzhardinge wrote:
>>>> On 09/12/2011 06:33 PM, Jeremy Fitzhardinge wrote:
>>>>> Hi all,
>>>>>
>>>>> I reported a regression in connecting my Nokia BH-905i headphones in
>>>>> June this year (https://lkml.org/lkml/2011/6/23/770), which was the same
>>>>> problem Keith Packard reported in https://lkml.org/lkml/2011/6/9/63.  
>>>>> It was briefly fixed in
>>>>> git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git.
>>>>>
>>>>> Unfortunately it regressed again by the time of the linux-3.0 release,
>>>>> to something with similar symptoms: the headphones won't reliably
>>>>> connect to my laptop unless I freshly re-pair them.  However, unlike the
>>>>> original bug, they will very occasionally connect normally, though I
>>>>> don't know why.
>>>>>
>>>>> This behaviour has been consistent since 3.0 up until the current
>>>>> 3.1-rc6 kernel.
>>>>>
>>>>> What further information can I provide?  How can I help debug this?
>>>> I turned on debugging by running "bluetoothd -n -d", and got the
>>>> following when trying to connect my headphones:
>>>>
>>>> Sep 16 15:30:47 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:headset_set_state() State changed /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D: HEADSET_STATE_DISCONNECTED -> HEADSET_STATE_CONNECTING
>>>> Sep 16 15:30:47 saboo bluetoothd[22025]: bluetoothd[22025]: src/adapter.c:adapter_get_device() 00:0B:E4:A6:6C:0D
>>>> Sep 16 15:30:47 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:remote_features_information() hci0 status 0
>>>> Sep 16 15:30:48 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:remote_name_information() hci0 status 0
>>>> Sep 16 15:30:48 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:headset_set_channel() Discovered Handsfree service on channel 1
>>>> Sep 16 15:30:48 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:rfcomm_connect() /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D: Connecting to 00:0B:E4:A6:6C:0D channel 1
>>>> Sep 16 15:30:48 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:link_key_request() hci0 dba 00:0B:E4:A6:6C:0D
>>>> Sep 16 15:30:48 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:link_key_request() kernel auth requirements = 0x04
>>>> Sep 16 15:30:48 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:link_key_request() Matching key found
>>>> Sep 16 15:30:48 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:link_key_request() link key type 0x04
>>>> Sep 16 15:30:48 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:auth_complete() hci0 status 0
>>>> Sep 16 15:30:48 saboo bluetoothd[22025]: bluetoothd[22025]: src/event.c:btd_event_bonding_process_complete() status=00
>>>> Sep 16 15:30:48 saboo bluetoothd[22025]: bluetoothd[22025]: src/adapter.c:adapter_get_device() 00:0B:E4:A6:6C:0D
>>>> Sep 16 15:30:48 saboo bluetoothd[22025]: bluetoothd[22025]: src/event.c:btd_event_bonding_process_complete() no pending auth request
>>>> Sep 16 15:30:50 saboo bluetoothd[22025]: bluetoothd[22025]: Permission denied (13)
>>>> Sep 16 15:30:50 saboo bluetoothd[22025]: Permission denied (13)
>>>> Sep 16 15:30:50 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:headset_set_state() State changed /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D: HEADSET_STATE_CONNECTING -> HEADSET_STATE_DISCONNECTED
>>>> Sep 16 15:30:50 saboo bluetoothd[22025]: bluetoothd[22025]: src/adapter.c:adapter_get_device() 00:0B:E4:A6:6C:0D
>>>>
>>> And I get this when I successfully re-pair and connect the headphones:
>>>
>>> Sep 16 15:36:30 saboo bluetoothd[22025]: Discovery session 0x7f1059478630 with :1.326 activated
>>> Sep 16 15:36:30 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:hciops_start_inquiry() hci0 length 8 periodic 1
>>> Sep 16 15:36:30 saboo bluetoothd[22025]: bluetoothd[22025]: Discovery session 0x7f1059478630 with :1.326 activated
>>> Sep 16 15:36:30 saboo bluetoothd[22025]: bluetoothd[22025]: src/adapter.c:session_ref() 0x7f1059478630: ref=1
>>> Sep 16 15:36:35 saboo bluetoothd[22025]: bluetoothd[22025]: src/adapter.c:session_unref() 0x7f1059478630: ref=0
>>> Sep 16 15:36:35 saboo bluetoothd[22025]: bluetoothd[22025]: src/adapter.c:session_remove() Discovery session 0x7f1059478630 with :1.326 deactivated
>>> Sep 16 15:36:35 saboo bluetoothd[22025]: bluetoothd[22025]: src/adapter.c:session_remove() Stopping discovery
>>> Sep 16 15:36:35 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:hciops_stop_inquiry() hci0
>>> Sep 16 15:36:35 saboo bluetoothd[22025]: Stopping discovery
>>> Sep 16 15:36:35 saboo bluetoothd[22025]: bluetoothd[22025]: Stopping discovery
>>> Sep 16 15:36:35 saboo bluetoothd[22025]: Inquiry Failed with status 0x12
>>> Sep 16 15:36:35 saboo bluetoothd[22025]: bluetoothd[22025]: Inquiry Failed with status 0x12
>>> Sep 16 15:36:35 saboo bluetoothd[22025]: bluetoothd[22025]: src/adapter.c:adapter_create_device() 00:0B:E4:A6:6C:0D
>>> Sep 16 15:36:35 saboo bluetoothd[22025]: bluetoothd[22025]: src/device.c:device_create() Creating device /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D
>>> Sep 16 15:36:35 saboo bluetoothd[22025]: bluetoothd[22025]: src/device.c:btd_device_ref() 0x7f105947ef70: ref=1
>>> Sep 16 15:36:35 saboo bluetoothd[22025]: bluetoothd[22025]: src/device.c:bonding_request_new() Requesting bonding for 00:0B:E4:A6:6C:0D
>>> Sep 16 15:36:35 saboo bluetoothd[22025]: bluetoothd[22025]: src/device.c:bonding_request_new() Temporary agent registered for 00:0B:E4:A6:6C:0D at :1.326:/org/bluez/agent/wizard
>>> Sep 16 15:36:42 saboo bluetoothd[22025]: bluetoothd[22025]: src/adapter.c:adapter_get_device() 00:0B:E4:A6:6C:0D
>>> Sep 16 15:36:42 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:remote_features_information() hci0 status 0
>>> Sep 16 15:36:42 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:remote_name_information() hci0 status 0
>>> Sep 16 15:36:42 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:link_key_request() hci0 dba 00:0B:E4:A6:6C:0D
>>> Sep 16 15:36:42 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:link_key_request() kernel auth requirements = 0x03
>>> Sep 16 15:36:42 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:link_key_request() Matching key not found
>>> Sep 16 15:36:42 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:io_capa_request() hci0 IO capability request for 00:0B:E4:A6:6C:0D
>>> Sep 16 15:36:42 saboo bluetoothd[22025]: bluetoothd[22025]: src/adapter.c:adapter_get_device() 00:0B:E4:A6:6C:0D
>>> Sep 16 15:36:42 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:hciops_get_auth_info() hci0 dba 00:0B:E4:A6:6C:0D
>>> Sep 16 15:36:42 saboo bluetoothd[22025]: bluetoothd[22025]: src/event.c:btd_event_get_io_cap() initial authentication requirement is 0x03
>>> Sep 16 15:36:42 saboo bluetoothd[22025]: bluetoothd[22025]: src/event.c:btd_event_get_io_cap() final authentication requirement is 0x03
>>> Sep 16 15:36:44 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:io_capa_response() hci0 IO capability response from 00:0B:E4:A6:6C:0D
>>> Sep 16 15:36:44 saboo bluetoothd[22025]: bluetoothd[22025]: src/adapter.c:adapter_get_device() 00:0B:E4:A6:6C:0D
>>> Sep 16 15:36:46 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:user_confirm_request() hci0
>>> Sep 16 15:36:46 saboo bluetoothd[22025]: bluetoothd[22025]: src/adapter.c:adapter_get_device() 00:0B:E4:A6:6C:0D
>>> Sep 16 15:36:46 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:hciops_get_auth_info() hci0 dba 00:0B:E4:A6:6C:0D
>>> Sep 16 15:36:46 saboo bluetoothd[22025]: bluetoothd[22025]: src/event.c:btd_event_user_confirm() confirm IO capabilities are 0x01
>>> Sep 16 15:36:46 saboo bluetoothd[22025]: bluetoothd[22025]: src/event.c:btd_event_user_confirm() confirm authentication requirement is 0x03
>>> Sep 16 15:36:46 saboo bluetoothd[22025]: bluetoothd[22025]: src/event.c:btd_event_user_confirm() remote IO capabilities are 0x03
>>> Sep 16 15:36:46 saboo bluetoothd[22025]: bluetoothd[22025]: src/event.c:btd_event_user_confirm() remote authentication requirement is 0x02
>>> Sep 16 15:36:46 saboo bluetoothd[22025]: bluetoothd[22025]: src/event.c:btd_event_user_confirm() auto accept of confirmation
>>> Sep 16 15:36:46 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:hciops_confirm_reply() hci0 dba 00:0B:E4:A6:6C:0D success 1
>>> Sep 16 15:36:46 saboo bluetoothd[22025]: bluetoothd[22025]: src/device.c:device_request_authentication() Requesting agent authentication for 00:0B:E4:A6:6C:0D
>>> Sep 16 15:36:49 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:simple_pairing_complete() hci0 status 0
>>> Sep 16 15:36:49 saboo bluetoothd[22025]: bluetoothd[22025]: src/event.c:btd_event_simple_pairing_complete() status=00
>>> Sep 16 15:36:49 saboo bluetoothd[22025]: bluetoothd[22025]: src/adapter.c:adapter_get_device() 00:0B:E4:A6:6C:0D
>>> Sep 16 15:36:49 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:link_key_notify() hci0 dba 00:0B:E4:A6:6C:0D type 4
>>> Sep 16 15:36:49 saboo bluetoothd[22025]: bluetoothd[22025]: src/adapter.c:adapter_get_device() 00:0B:E4:A6:6C:0D
>>> Sep 16 15:36:49 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:hciops_get_auth_info() hci0 dba 00:0B:E4:A6:6C:0D
>>> Sep 16 15:36:49 saboo bluetoothd[22025]: bluetoothd[22025]: src/event.c:btd_event_link_key_notify() key type 0x04 old key type 0xff new key type 0x04
>>> Sep 16 15:36:49 saboo bluetoothd[22025]: bluetoothd[22025]: src/event.c:btd_event_link_key_notify() local auth 0x03 and remote auth 0x02
>>> Sep 16 15:36:49 saboo bluetoothd[22025]: bluetoothd[22025]: src/event.c:btd_event_link_key_notify() storing link key of type 0x04
>>> Sep 16 15:36:49 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:auth_complete() hci0 status 0
>>> Sep 16 15:36:49 saboo bluetoothd[22025]: bluetoothd[22025]: src/event.c:btd_event_bonding_process_complete() status=00
>>> Sep 16 15:36:49 saboo bluetoothd[22025]: bluetoothd[22025]: src/adapter.c:adapter_get_device() 00:0B:E4:A6:6C:0D
>>> Sep 16 15:36:49 saboo bluetoothd[22025]: bluetoothd[22025]: src/device.c:btd_device_ref() 0x7f105947ef70: ref=2
>>> Sep 16 15:36:49 saboo bluetoothd[22025]: bluetoothd[22025]: src/agent.c:agent_release() Releasing agent :1.326, /org/bluez/agent/wizard
>>> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: src/device.c:device_probe_drivers() Probing drivers for 00:0B:E4:A6:6C:0D
>>> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: serial/manager.c:serial_probe() path /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D: 0000111e-0000-1000-8000-00805f9b34fb
>>> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: serial/port.c:create_serial_device() Registered interface org.bluez.Serial on path /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D
>>> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: serial/manager.c:serial_probe() path /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D: 00001108-0000-1000-8000-00805f9b34fb
>>> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: input/manager.c:headset_probe() path /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D
>>> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: src/device.c:btd_device_ref() 0x7f105947ef70: ref=3
>>> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: input/device.c:input_device_new() Registered interface org.bluez.Input on path /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D
>>> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: src/adapter.c:adapter_get_device() 00:0B:E4:A6:6C:0D
>>> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: src/device.c:btd_device_ref() 0x7f105947ef70: ref=4
>>> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: audio/device.c:audio_device_register() Registered interface org.bluez.Audio on path /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D
>>> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: audio/manager.c:handle_uuid() Found Headset record
>>> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:headset_init() Registered interface org.bluez.Headset on path /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D
>>> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: audio/manager.c:handle_uuid() Found Handsfree record
>>> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: audio/manager.c:handle_uuid() Found Audio Sink
>>> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: audio/sink.c:sink_init() Registered interface org.bluez.AudioSink on path /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D
>>> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: audio/manager.c:handle_uuid() Found AV Target
>>> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: audio/control.c:control_init() Registered interface org.bluez.Control on path /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D
>>> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: audio/manager.c:handle_uuid() Found AV Remote
>>> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: src/device.c:btd_device_unref() 0x7f105947ef70: ref=3
>>> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:headset_set_state() State changed /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D: HEADSET_STATE_DISCONNECTED -> HEADSET_STATE_CONNECTING
>>> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:headset_set_channel() Discovered Handsfree service on channel 1
>>> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:rfcomm_connect() /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D: Connecting to 00:0B:E4:A6:6C:0D channel 1
>>> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:headset_connect_cb() /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D: Connected to 00:0B:E4:A6:6C:0D
>>> Sep 16 15:36:51 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:handle_event() Received AT+BRSF=25
>>> Sep 16 15:36:51 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:print_hf_features() HFP HF features: "EC and/or NR function" "Voice recognition activation" "Remote volume control"
>>> Sep 16 15:36:51 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:handle_event() Received AT+CIND=?
>>> Sep 16 15:36:51 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:handle_event() Received AT+CIND?
>>> Sep 16 15:36:51 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:handle_event() Received AT+CMER=3, 0, 0, 1
>>> Sep 16 15:36:51 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:event_reporting() Event reporting (CMER): mode=3, ind=1
>>> Sep 16 15:36:51 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:hfp_slc_complete() HFP Service Level Connection established
>>> Sep 16 15:36:51 saboo bluetoothd[22025]: bluetoothd[22025]: audio/telephony.c:telephony_device_connected() telephony-dummy: device 0x7f1059492390 connected
>>> Sep 16 15:36:51 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:headset_set_state() State changed /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D: HEADSET_STATE_CONNECTING -> HEADSET_STATE_CONNECTED
>>> Sep 16 15:36:52 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:handle_event() Received AT+VGS=10
>>> Sep 16 15:36:52 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:handle_event() Received AT+VGM=10
>>> Sep 16 15:36:52 saboo bluetoothd[22025]: Badly formated or unrecognized command: AT+CSRSF=1,1,1,1,1,7
>>> Sep 16 15:36:52 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:handle_event() Received AT+CSRSF=1,1,1,1,1,7
>>> Sep 16 15:36:52 saboo bluetoothd[22025]: bluetoothd[22025]: Badly formated or unrecognized command: AT+CSRSF=1,1,1,1,1,7
>>> Sep 16 15:36:53 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_ref() 0x7f105947b330: ref=2
>>> Sep 16 15:36:53 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_ref() 0x7f105947b330: ref=3
>>> Sep 16 15:36:53 saboo bluetoothd[22025]: bluetoothd[22025]: audio/sink.c:sink_set_state() State changed /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D: SINK_STATE_DISCONNECTED -> SINK_STATE_CONNECTING
>>> Sep 16 15:36:53 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_unref() 0x7f105947b330: ref=2
>>> Sep 16 15:36:53 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_connect_cb() AVDTP: connected signaling channel to 00:0B:E4:A6:6C:0D
>>> Sep 16 15:36:53 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_connect_cb() AVDTP imtu=672, omtu=895
>>> Sep 16 15:36:53 saboo bluetoothd[22025]: bluetoothd[22025]: audio/control.c:avctp_set_state() AVCTP Connecting
>>> Sep 16 15:36:53 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:session_cb()
>>> Sep 16 15:36:53 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_parse_resp() DISCOVER request succeeded
>>> Sep 16 15:36:53 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_discover_resp() seid 1 type 1 media 0 in use 0
>>> Sep 16 15:36:53 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_discover_resp() seid 2 type 1 media 0 in use 0
>>> Sep 16 15:36:53 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_discover_resp() seid 4 type 1 media 0 in use 0
>>> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:session_cb()
>>> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_parse_resp() GET_CAPABILITIES request succeeded
>>> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_get_capabilities_resp() seid 1 type 1 media 0
>>> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:session_cb()
>>> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_parse_resp() GET_CAPABILITIES request succeeded
>>> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_get_capabilities_resp() seid 2 type 1 media 0
>>> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:session_cb()
>>> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_parse_resp() GET_CAPABILITIES request succeeded
>>> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_get_capabilities_resp() seid 4 type 1 media 0
>>> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/sink.c:discovery_complete() Discovery complete
>>> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_ref() 0x7f105947b330: ref=3
>>> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/a2dp.c:setup_ref() 0x7f105947e3f0: ref=1
>>> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/a2dp.c:a2dp_config() a2dp_config: selected SEP 0x7f1059476ad0
>>> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/a2dp.c:setup_ref() 0x7f105947e3f0: ref=2
>>> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_set_configuration() 0x7f105947b330: int_seid=1, acp_seid=1
>>> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/a2dp.c:setup_unref() 0x7f105947e3f0: ref=1
>>> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:session_cb()
>>> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_parse_resp() SET_CONFIGURATION request succeeded
>>> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/a2dp.c:setconf_cfm() Source 0x7f1059476ad0: Set_Configuration_Cfm
>>> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_sep_set_state() stream state changed: IDLE -> CONFIGURED
>>> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/control.c:avctp_connect_cb() AVCTP: connected to 00:0B:E4:A6:6C:0D
>>> Sep 16 15:36:54 saboo kernel: [93473.952314] input: 00:0B:E4:A6:6C:0D as /devices/virtual/input/input31
>>> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/control.c:init_uinput() AVRCP: uinput initialized for 00:0B:E4:A6:6C:0D
>>> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/control.c:avctp_set_state() AVCTP Connected
>>> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:session_cb()
>>> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_parse_resp() OPEN request succeeded
>>> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_connect_cb() AVDTP: connected transport channel to 00:0B:E4:A6:6C:0D
>>> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:handle_transport_connect() sk 29, omtu 895, send buffer size 63488
>>> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/a2dp.c:open_cfm() Source 0x7f1059476ad0: Open_Cfm
>>> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/sink.c:stream_setup_complete() Stream successfully created
>>> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/a2dp.c:setup_unref() 0x7f105947e3f0: ref=0
>>> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/a2dp.c:setup_free() 0x7f105947e3f0
>>> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_unref() 0x7f105947b330: ref=2
>>> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_sep_set_state() stream state changed: CONFIGURED -> OPEN
>>> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/sink.c:sink_set_state() State changed /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D: SINK_STATE_CONNECTING -> SINK_STATE_CONNECTED
>>> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/unix.c:server_cb() Accepted new client connection on unix socket (fd=30)
>>> Sep 16 15:36:54 saboo rsyslogd-2177: imuxsock begins to drop messages from pid 22025 due to rate-limiting
>>> Sep 16 22:36:54 saboo rtkit-daemon[1543]: Successfully made thread 22178 of process 1866 (/usr/bin/pulseaudio) owned by '500' RT at priority 5.
>>> Sep 16 15:36:55 saboo rsyslogd-2177: imuxsock lost 52 messages from pid 22025 due to rate-limiting
>>> Sep 16 15:36:55 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:session_cb()
>>> Sep 16 15:36:55 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_parse_resp() START request succeeded
>>> Sep 16 15:36:55 saboo bluetoothd[22025]: bluetoothd[22025]: audio/a2dp.c:start_cfm() Source 0x7f1059476ad0: Start_Cfm
>>> Sep 16 15:36:55 saboo bluetoothd[22025]: bluetoothd[22025]: audio/unix.c:unix_ipc_sendmsg() Audio API: BT_RESPONSE -> BT_START_STREAM
>>> Sep 16 15:36:55 saboo bluetoothd[22025]: bluetoothd[22025]: audio/unix.c:unix_ipc_sendmsg() Audio API: BT_RESPONSE -> BT_NEW_STREAM
>>> Sep 16 15:36:55 saboo bluetoothd[22025]: bluetoothd[22025]: audio/a2dp.c:setup_unref() 0x7f105947e3f0: ref=0
>>> Sep 16 15:36:55 saboo bluetoothd[22025]: bluetoothd[22025]: audio/a2dp.c:setup_free() 0x7f105947e3f0
>>> Sep 16 15:36:55 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_unref() 0x7f105947b330: ref=3
>>> Sep 16 15:36:55 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_sep_set_state() stream state changed: OPEN -> STREAMING
>>> Sep 16 15:36:55 saboo bluetoothd[22025]: bluetoothd[22025]: audio/sink.c:sink_set_state() State changed /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D: SINK_STATE_CONNECTED -> SINK_STATE_PLAYING
>>>
>>> Thanks,
>>> 	J
>>
>> I tried to bisect this with inconclusive results.
>>
>> Firstly, it was all working fine up until 13d39315 "Bluetooth: Map
>> sec_level to link key requirements".  This had a couple of known bugs
>> fixed with 6fdf658c "Bluetooth: Fix L2CAP security check" and 33060542
>> "Bluetooth: Fix L2CAP connection establishment".  When I cherry-picked
>> just those onto 13d39315 it all seems to work well again.
>>
>> However, after that, it regresses again, and reconnection gets pretty
>> unreliable.  From bisection of a linearized history of the net/bluetooth
>> changes, it appears that 60b83f57 "Bluetooth: Ignore key unauthenticated
>> for high security" is at least part of the problem, and when I revert it
>> from the bluetooth branch it seems to help; but when I revert it from an
>> overall v3.1 linux.git head, it doesn't, so perhaps something else in
>> there is also causing a problem.
>>
>> It seems clear that all the new stricter enforcement of security stuff
>> is upsetting my headphone's reconnection, but I've reached the limit of
>> how much I can diagnose this without some pointers, because I don't
>> really know anything about bluetooth.
>>
>> How can I help fix this?
> Can you send me the hcidump logs of both the working and not working
> scenarios? It helps a lot find issues.
>

OK, here's some traces.

These were all with a current linux.git tip of tree without rebooting. I
got it to connect several times successfully, which is unusually
frequent (perhaps its timing related and hcidump helped?).

The two failures are once when initiating the connection from the
headphones, and the other from within the gnome3 bluetooth gui.

Thanks,
    J

--------------000703080002070601080608
Content-Type: text/plain;
 name="v3.1-successful-disconnect.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="v3.1-successful-disconnect.txt"

HCI sniffer - Bluetooth packet analyzer ver 2.0
device: hci0 snap_len: 1028 filter: 0xffffffffffffffff
2011-09-29 14:00:19.029654 > HCI Event: Inquiry Complete (0x01) plen 1
    status 0x00
2011-09-29 14:00:24.734091 > ACL data: handle 12 flags 0x02 dlen 7
    L2CAP(d): cid 0x0042 len 3 [psm 0]
      0000: 10 0a 04                                          ...
2011-09-29 14:00:24.734835 < ACL data: handle 12 flags 0x00 dlen 6
    0000: 02 00 43 00 12 0a                                 ..C...
2011-09-29 14:00:24.734858 < HCI Command: Exit Sniff Mode (0x02|0x0004) plen 2
    handle 12
2011-09-29 14:00:24.739573 > HCI Event: Max Slots Change (0x1b) plen 3
    handle 12 slots 5
2011-09-29 14:00:24.740478 > HCI Event: Mode Change (0x14) plen 6
    status 0x00 handle 12 mode 0x00 interval 0
    Mode: Active
2011-09-29 14:00:24.741473 > HCI Event: Command Status (0x0f) plen 4
    Exit Sniff Mode (0x02|0x0004) status 0x0c ncmd 1
    Error: Command Disallowed
2011-09-29 14:00:24.875229 > ACL data: handle 12 flags 0x02 dlen 12
    L2CAP(s): Disconn req: dcid 0x0041 scid 0x0044
2011-09-29 14:00:24.875533 < ACL data: handle 12 flags 0x00 dlen 12
    0000: 08 00 01 00 07 0d 04 00  41 00 44 00              ........A.D.
2011-09-29 14:00:24.876466 > ACL data: handle 12 flags 0x02 dlen 8
    L2CAP(d): cid 0x0040 len 4 [psm 0]
      0000: 6b 53 01 06                                       kS..
2011-09-29 14:00:24.876654 < ACL data: handle 12 flags 0x00 dlen 8
    0000: 04 00 41 00 6b 73 01 2c                           ..A.ks.,
2011-09-29 14:00:24.879561 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 12 packets 2
2011-09-29 14:00:24.984086 > ACL data: handle 12 flags 0x02 dlen 8
    L2CAP(d): cid 0x0040 len 4 [psm 0]
      0000: 03 53 01 fd                                       .S..
2011-09-29 14:00:24.984484 < ACL data: handle 12 flags 0x00 dlen 8
    0000: 04 00 41 00 03 73 01 d7                           ..A..s..
2011-09-29 14:00:24.988485 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 12 packets 2
2011-09-29 14:00:25.016467 > ACL data: handle 12 flags 0x02 dlen 12
    L2CAP(s): Disconn req: dcid 0x0043 scid 0x0045
2011-09-29 14:00:25.016675 < ACL data: handle 12 flags 0x00 dlen 12
    0000: 08 00 01 00 07 0e 04 00  43 00 45 00              ........C.E.
2011-09-29 14:00:25.017711 > ACL data: handle 12 flags 0x02 dlen 12
    L2CAP(s): Disconn req: dcid 0x0040 scid 0x0041
2011-09-29 14:00:25.017783 < ACL data: handle 12 flags 0x00 dlen 12
    0000: 08 00 01 00 07 0f 04 00  40 00 41 00              ........@.A.
2011-09-29 14:00:25.022558 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 12 packets 2
2011-09-29 14:00:26.031508 > ACL data: handle 12 flags 0x02 dlen 12
    L2CAP(s): Disconn req: dcid 0x0042 scid 0x0043
2011-09-29 14:00:26.032171 < ACL data: handle 12 flags 0x00 dlen 12
    0000: 08 00 01 00 07 10 04 00  42 00 43 00              ........B.C.
2011-09-29 14:00:26.164538 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 12 packets 1
2011-09-29 14:00:26.464548 > HCI Event: Disconn Complete (0x05) plen 4
    status 0x00 handle 12 reason 0x13
    Reason: Remote User Terminated Connection

--------------000703080002070601080608
Content-Type: text/plain;
 name="v3.1-failed-device-connect.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="v3.1-failed-device-connect.txt"

HCI sniffer - Bluetooth packet analyzer ver 2.0
device: hci0 snap_len: 1028 filter: 0xffffffffffffffff
2011-09-29 14:00:42.067241 > HCI Event: Inquiry Complete (0x01) plen 1
    status 0x00
2011-09-29 14:00:48.223231 > HCI Event: Connect Request (0x04) plen 10
    bdaddr 00:0B:E4:A6:6C:0D class 0x240404 type ACL
2011-09-29 14:00:48.223380 < HCI Command: Accept Connection Request (0x01|0x0009) plen 7
    bdaddr 00:0B:E4:A6:6C:0D role 0x00
    Role: Master
2011-09-29 14:00:48.225134 > HCI Event: Command Status (0x0f) plen 4
    Accept Connection Request (0x01|0x0009) status 0x00 ncmd 1
2011-09-29 14:00:48.388140 > HCI Event: Role Change (0x12) plen 8
    status 0x00 bdaddr 00:0B:E4:A6:6C:0D role 0x00
    Role: Master
2011-09-29 14:00:48.555229 > HCI Event: Connect Complete (0x03) plen 11
    status 0x00 handle 11 bdaddr 00:0B:E4:A6:6C:0D type ACL encrypt 0x00
2011-09-29 14:00:48.555476 < HCI Command: Read Remote Supported Features (0x01|0x001b) plen 2
    handle 11
2011-09-29 14:00:48.557128 > HCI Event: Command Status (0x0f) plen 4
    Read Remote Supported Features (0x01|0x001b) status 0x00 ncmd 1
2011-09-29 14:00:48.558126 > HCI Event: Read Remote Supported Features (0x0b) plen 11
    status 0x00 handle 11
    Features: 0xff 0xfe 0x0f 0xc6 0x9b 0xff 0x59 0x83
2011-09-29 14:00:48.558234 < HCI Command: Read Remote Extended Features (0x01|0x001c) plen 3
    handle 11 page 1
2011-09-29 14:00:48.560131 > HCI Event: Command Status (0x0f) plen 4
    Read Remote Extended Features (0x01|0x001c) status 0x00 ncmd 1
2011-09-29 14:00:48.566136 > HCI Event: Max Slots Change (0x1b) plen 3
    handle 11 slots 5
2011-09-29 14:00:48.597222 > HCI Event: Read Remote Extended Features (0x23) plen 13
    status 0x00 handle 11 page 1 max 1
    Features: 0x01 0x00 0x00 0x00 0x00 0x00 0x00 0x00
2011-09-29 14:00:48.597451 < HCI Command: Remote Name Request (0x01|0x0019) plen 10
    bdaddr 00:0B:E4:A6:6C:0D mode 2 clkoffset 0x0000
2011-09-29 14:00:48.599227 > HCI Event: Command Status (0x0f) plen 4
    Remote Name Request (0x01|0x0019) status 0x00 ncmd 1
2011-09-29 14:00:48.641497 > ACL data: handle 11 flags 0x02 dlen 12
    L2CAP(s): Connect req: psm 1 scid 0x0040
2011-09-29 14:00:48.641628 < ACL data: handle 11 flags 0x00 dlen 16
    0000: 0c 00 01 00 03 02 08 00  40 00 40 00 01 00 00 00  ........@.@.....
2011-09-29 14:00:48.641640 < ACL data: handle 11 flags 0x00 dlen 10
    0000: 06 00 01 00 0a 01 02 00  02 00                    ..........
2011-09-29 14:00:48.652867 > ACL data: handle 11 flags 0x02 dlen 16
    L2CAP(s): Info rsp: type 2 result 0
      Extended feature mask 0x0000
2011-09-29 14:00:48.652952 < ACL data: handle 11 flags 0x00 dlen 16
    0000: 0c 00 01 00 03 02 08 00  40 00 40 00 00 00 00 00  ........@.@.....
2011-09-29 14:00:48.652962 < ACL data: handle 11 flags 0x00 dlen 12
    0000: 08 00 01 00 04 02 04 00  40 00 00 00              ........@...
2011-09-29 14:00:48.657117 > HCI Event: Remote Name Req Complete (0x07) plen 255
    status 0x00 bdaddr 00:0B:E4:A6:6C:0D name 'Nokia BH-905i'
2011-09-29 14:00:48.658129 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 11 packets 2
2011-09-29 14:00:48.659123 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 11 packets 2
2011-09-29 14:00:48.666690 > ACL data: handle 11 flags 0x02 dlen 16
    L2CAP(s): Config req: dcid 0x0040 flags 0x00 clen 4
      MTU 48 
2011-09-29 14:00:48.666912 < ACL data: handle 11 flags 0x00 dlen 18
    0000: 0e 00 01 00 05 03 0a 00  40 00 00 00 00 00 01 02  ........@.......
    0010: 30 00                                             0.
2011-09-29 14:00:48.667871 > ACL data: handle 11 flags 0x02 dlen 14
    L2CAP(s): Config rsp: scid 0x0040 flags 0x00 result 0 clen 0
      Success
2011-09-29 14:00:48.701625 > ACL data: handle 11 flags 0x02 dlen 24
    L2CAP(d): cid 0x0040 len 20 [psm 0]
      0000: 06 00 01 00 0f 35 05 1a  00 00 11 1f 00 26 35 03  .....5.......&5.
      0010: 09 00 04 00                                       ....
2011-09-29 14:00:48.701968 < ACL data: handle 11 flags 0x00 dlen 33
    0000: 1d 00 40 00 07 00 01 00  18 00 15 35 13 35 11 09  ..@........5.5..
    0010: 00 04 35 0c 35 03 19 01  00 35 05 19 00 03 08 0d  ..5.5....5......
    0020: 00                                                .
2011-09-29 14:00:48.706148 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 11 packets 2
2011-09-29 14:00:48.736495 > ACL data: handle 11 flags 0x02 dlen 12
    L2CAP(s): Disconn req: dcid 0x0040 scid 0x0040
2011-09-29 14:00:48.736574 < ACL data: handle 11 flags 0x00 dlen 12
    0000: 08 00 01 00 07 04 04 00  40 00 40 00              ........@.@.
2011-09-29 14:00:48.879221 > HCI Event: Link Key Request (0x17) plen 6
    bdaddr 00:0B:E4:A6:6C:0D
2011-09-29 14:00:48.879895 < HCI Command: Link Key Request Reply (0x01|0x000b) plen 22
    bdaddr 00:0B:E4:A6:6C:0D key 08AB2E2A1319F534321C46393A25B42D
2011-09-29 14:00:48.887206 > HCI Event: Command Complete (0x0e) plen 10
    Link Key Request Reply (0x01|0x000b) ncmd 1
    status 0x00 bdaddr 00:0B:E4:A6:6C:0D
2011-09-29 14:00:48.914122 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 11 packets 1
2011-09-29 14:00:48.981219 > HCI Event: Encrypt Change (0x08) plen 4
    status 0x00 handle 11 encrypt 0x01
2011-09-29 14:00:48.984117 > ACL data: handle 11 flags 0x02 dlen 12
    L2CAP(s): Connect req: psm 3 scid 0x0041
2011-09-29 14:00:48.984277 < ACL data: handle 11 flags 0x00 dlen 16
    0000: 0c 00 01 00 03 05 08 00  40 00 41 00 00 00 00 00  ........@.A.....
2011-09-29 14:00:48.984286 < ACL data: handle 11 flags 0x00 dlen 16
    0000: 0c 00 01 00 04 03 08 00  41 00 00 00 01 02 f5 03  ........A.......
2011-09-29 14:00:48.990122 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 11 packets 2
2011-09-29 14:00:49.020425 > ACL data: handle 11 flags 0x02 dlen 16
    L2CAP(s): Config req: dcid 0x0040 flags 0x00 clen 4
      MTU 895 
2011-09-29 14:00:49.020601 < ACL data: handle 11 flags 0x00 dlen 18
    0000: 0e 00 01 00 05 06 0a 00  41 00 00 00 00 00 01 02  ........A.......
    0010: 7f 03                                             ..
2011-09-29 14:00:49.021667 > ACL data: handle 11 flags 0x02 dlen 18
    L2CAP(s): Config rsp: scid 0x0040 flags 0x00 result 0 clen 4
      MTU 1013 
2011-09-29 14:00:49.055368 > ACL data: handle 11 flags 0x02 dlen 8
    L2CAP(d): cid 0x0040 len 4 [psm 0]
      0000: 03 3f 01 1c                                       .?..
2011-09-29 14:00:49.055578 < ACL data: handle 11 flags 0x00 dlen 8
    0000: 04 00 41 00 03 73 01 d7                           ..A..s..
2011-09-29 14:00:49.060224 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 11 packets 2
2011-09-29 14:00:49.165464 > ACL data: handle 11 flags 0x02 dlen 18
    L2CAP(d): cid 0x0040 len 14 [psm 0]
      0000: 03 ef 15 83 11 1a f0 00  00 7e 00 00 00 70        .........~...p
2011-09-29 14:00:49.165779 < ACL data: handle 11 flags 0x00 dlen 18
    0000: 0e 00 41 00 01 ef 15 81  11 1a e0 00 00 7e 00 00  ..A..........~..
    0010: 07 aa                                             ..
2011-09-29 14:00:49.200392 > ACL data: handle 11 flags 0x02 dlen 8
    L2CAP(d): cid 0x0040 len 4 [psm 0]
      0000: 6b 3f 01 e7                                       k?..
2011-09-29 14:00:49.200555 < HCI Command: Authentication Requested (0x01|0x0011) plen 2
    handle 11
2011-09-29 14:00:49.202130 > HCI Event: Command Status (0x0f) plen 4
    Authentication Requested (0x01|0x0011) status 0x00 ncmd 1
2011-09-29 14:00:49.203117 > HCI Event: Link Key Request (0x17) plen 6
    bdaddr 00:0B:E4:A6:6C:0D
2011-09-29 14:00:49.203516 < HCI Command: Link Key Request Reply (0x01|0x000b) plen 22
    bdaddr 00:0B:E4:A6:6C:0D key 08AB2E2A1319F534321C46393A25B42D
2011-09-29 14:00:49.215121 > HCI Event: Command Complete (0x0e) plen 10
    Link Key Request Reply (0x01|0x000b) ncmd 1
    status 0x00 bdaddr 00:0B:E4:A6:6C:0D
2011-09-29 14:00:49.241116 > HCI Event: Auth Complete (0x06) plen 3
    status 0x00 handle 11
2011-09-29 14:00:49.241478 < ACL data: handle 11 flags 0x00 dlen 8
    0000: 04 00 41 00 6b 73 01 2c                           ..A.ks.,
2011-09-29 14:00:49.241508 < ACL data: handle 11 flags 0x00 dlen 12
    0000: 08 00 41 00 01 ef 09 e3  05 6b 8d aa              ..A......k..
2011-09-29 14:00:49.310216 > HCI Event: Encryption Key Refresh Complete (0x30) plen 3
    status 0x00 handle 11
2011-09-29 14:00:49.415139 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 11 packets 1
2011-09-29 14:01:07.669939 > HCI Event: Inquiry Complete (0x01) plen 1
    status 0x00
2011-09-29 14:01:28.153554 > HCI Event: Inquiry Complete (0x01) plen 1
    status 0x00
2011-09-29 14:01:48.894509 > ACL data: handle 11 flags 0x02 dlen 8
    L2CAP(d): cid 0x0040 len 4 [psm 0]
      0000: 6b 53 01 06                                       kS..
2011-09-29 14:01:48.894991 < ACL data: handle 11 flags 0x00 dlen 8
    0000: 04 00 41 00 6b 73 01 2c                           ..A.ks.,
2011-09-29 14:01:48.964261 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 11 packets 2
2011-09-29 14:01:49.029557 > ACL data: handle 11 flags 0x02 dlen 8
    L2CAP(d): cid 0x0040 len 4 [psm 0]
      0000: 69 1f 01 ac                                       i...
2011-09-29 14:01:49.030753 > ACL data: handle 11 flags 0x02 dlen 8
    L2CAP(d): cid 0x0040 len 4 [psm 0]
      0000: 03 53 01 fd                                       .S..
2011-09-29 14:01:49.031083 < ACL data: handle 11 flags 0x00 dlen 8
    0000: 04 00 41 00 03 73 01 d7                           ..A..s..
2011-09-29 14:01:49.099600 > ACL data: handle 11 flags 0x02 dlen 8
    L2CAP(d): cid 0x0040 len 4 [psm 0]
      0000: 69 1f 01 ac                                       i...
2011-09-29 14:01:49.101304 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 11 packets 2
2011-09-29 14:01:49.170876 > ACL data: handle 11 flags 0x02 dlen 12
    L2CAP(s): Disconn req: dcid 0x0040 scid 0x0041
2011-09-29 14:01:49.171015 < ACL data: handle 11 flags 0x00 dlen 12
    0000: 08 00 01 00 07 07 04 00  40 00 41 00              ........@.A.
2011-09-29 14:01:49.415302 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 11 packets 1
2011-09-29 14:01:49.654252 > HCI Event: Disconn Complete (0x05) plen 4
    status 0x00 handle 11 reason 0x13
    Reason: Remote User Terminated Connection
2011-09-29 14:01:49.917247 > HCI Event: Inquiry Complete (0x01) plen 1
    status 0x00
2011-09-29 14:02:18.068927 > HCI Event: Inquiry Complete (0x01) plen 1
    status 0x00
2011-09-29 14:02:44.944550 > HCI Event: Inquiry Complete (0x01) plen 1
    status 0x00

--------------000703080002070601080608
Content-Type: text/plain;
 name="v3.1-failed-host-connect.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="v3.1-failed-host-connect.txt"

HCI sniffer - Bluetooth packet analyzer ver 2.0
device: hci0 snap_len: 1028 filter: 0xffffffffffffffff
2011-09-29 14:03:09.257112 > HCI Event: Inquiry Complete (0x01) plen 1
    status 0x00
2011-09-29 14:03:11.442616 < HCI Command: Create Connection (0x01|0x0005) plen 13
    bdaddr 00:0B:E4:A6:6C:0D ptype 0xcc18 rswitch 0x01 clkoffset 0x0000
    Packet type: DM1 DM3 DM5 DH1 DH3 DH5 
2011-09-29 14:03:11.444074 > HCI Event: Command Status (0x0f) plen 4
    Create Connection (0x01|0x0005) status 0x00 ncmd 1
2011-09-29 14:03:11.742155 > HCI Event: Connect Complete (0x03) plen 11
    status 0x00 handle 11 bdaddr 00:0B:E4:A6:6C:0D type ACL encrypt 0x00
2011-09-29 14:03:11.742425 < HCI Command: Read Remote Supported Features (0x01|0x001b) plen 2
    handle 11
2011-09-29 14:03:11.744064 > HCI Event: Command Status (0x0f) plen 4
    Read Remote Supported Features (0x01|0x001b) status 0x00 ncmd 1
2011-09-29 14:03:11.745064 > HCI Event: Read Remote Supported Features (0x0b) plen 11
    status 0x00 handle 11
    Features: 0xff 0xfe 0x0f 0xc6 0x9b 0xff 0x59 0x83
2011-09-29 14:03:11.745252 < HCI Command: Read Remote Extended Features (0x01|0x001c) plen 3
    handle 11 page 1
2011-09-29 14:03:11.747069 > HCI Event: Command Status (0x0f) plen 4
    Read Remote Extended Features (0x01|0x001c) status 0x00 ncmd 1
2011-09-29 14:03:11.755067 > HCI Event: Page Scan Repetition Mode Change (0x20) plen 7
    bdaddr 00:0B:E4:A6:6C:0D mode 1
2011-09-29 14:03:11.756061 > HCI Event: Max Slots Change (0x1b) plen 3
    handle 11 slots 5
2011-09-29 14:03:11.803075 > HCI Event: Read Remote Extended Features (0x23) plen 13
    status 0x00 handle 11 page 1 max 1
    Features: 0x01 0x00 0x00 0x00 0x00 0x00 0x00 0x00
2011-09-29 14:03:11.803217 < HCI Command: Remote Name Request (0x01|0x0019) plen 10
    bdaddr 00:0B:E4:A6:6C:0D mode 2 clkoffset 0x0000
2011-09-29 14:03:11.803232 < ACL data: handle 11 flags 0x00 dlen 10
    0000: 06 00 01 00 0a 01 02 00  02 00                    ..........
2011-09-29 14:03:11.805141 > HCI Event: Command Status (0x0f) plen 4
    Remote Name Request (0x01|0x0019) status 0x00 ncmd 1
2011-09-29 14:03:11.840072 > ACL data: handle 11 flags 0x02 dlen 16
    L2CAP(s): Info rsp: type 2 result 0
      Extended feature mask 0x0000
2011-09-29 14:03:11.840261 < ACL data: handle 11 flags 0x00 dlen 12
    0000: 08 00 01 00 02 02 04 00  01 00 40 00              ..........@.
2011-09-29 14:03:11.849932 > ACL data: handle 11 flags 0x02 dlen 16
    L2CAP(s): Connect rsp: dcid 0x0042 scid 0x0040 result 1 status 2
      Connection pending - Authorization pending
2011-09-29 14:03:11.852481 > ACL data: handle 11 flags 0x02 dlen 16
    L2CAP(s): Connect rsp: dcid 0x0042 scid 0x0040 result 0 status 0
      Connection successful
2011-09-29 14:03:11.852645 < ACL data: handle 11 flags 0x00 dlen 12
    0000: 08 00 01 00 04 03 04 00  42 00 00 00              ........B...
2011-09-29 14:03:11.856142 > HCI Event: Remote Name Req Complete (0x07) plen 255
    status 0x00 bdaddr 00:0B:E4:A6:6C:0D name 'Nokia BH-905i'
2011-09-29 14:03:11.857059 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 11 packets 2
2011-09-29 14:03:11.887445 > ACL data: handle 11 flags 0x02 dlen 14
    L2CAP(s): Config rsp: scid 0x0040 flags 0x00 result 0 clen 0
      Success
2011-09-29 14:03:11.888677 > ACL data: handle 11 flags 0x02 dlen 16
    L2CAP(s): Config req: dcid 0x0040 flags 0x00 clen 4
      MTU 48 
2011-09-29 14:03:11.888916 < ACL data: handle 11 flags 0x00 dlen 18
    0000: 0e 00 01 00 05 02 0a 00  42 00 00 00 00 00 01 02  ........B.......
    0010: 30 00                                             0.
2011-09-29 14:03:11.888997 < ACL data: handle 11 flags 0x00 dlen 24
    0000: 14 00 42 00 06 00 00 00  0f 35 03 19 11 1e ff ff  ..B......5......
    0010: 35 05 0a 00 00 ff ff 00                           5.......
2011-09-29 14:03:11.893061 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 11 packets 2
2011-09-29 14:03:11.918808 > ACL data: handle 11 flags 0x02 dlen 52
    L2CAP(d): cid 0x0040 len 48 [psm 0]
      0000: 07 00 00 00 2b 00 26 36  00 5c 36 00 59 09 00 00  ....+.&6.\6.Y...
      0010: 0a 00 01 00 00 09 00 01  35 06 19 11 1e 19 12 03  ........5.......
      0020: 09 00 04 35 0c 35 03 19  01 00 35 05 19 02 00 39  ...5.5....5....9
2011-09-29 14:03:11.918996 < ACL data: handle 11 flags 0x00 dlen 26
    0000: 16 00 42 00 06 00 01 00  11 35 03 19 11 1e ff ff  ..B......5......
    0010: 35 05 0a 00 00 ff ff 02  00 39                    5........9
2011-09-29 14:03:11.923083 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 11 packets 2
2011-09-29 14:03:11.930055 > ACL data: handle 11 flags 0x02 dlen 52
    L2CAP(d): cid 0x0040 len 48 [psm 0]
      0000: 07 00 01 00 2b 00 26 00  03 08 01 09 00 06 35 09  ....+.&.......5.
      0010: 09 65 6e 09 00 6a 09 01  00 09 00 09 35 08 35 06  .en..j......5.5.
      0020: 19 11 1e 09 01 05 09 01  00 25 0f 48 61 02 00 13  .........%.Ha...
2011-09-29 14:03:11.930228 < ACL data: handle 11 flags 0x00 dlen 26
    0000: 16 00 42 00 06 00 02 00  11 35 03 19 11 1e ff ff  ..B......5......
    0010: 35 05 0a 00 00 ff ff 02  00 13                    5.........
2011-09-29 14:03:11.964933 > ACL data: handle 11 flags 0x02 dlen 31
    L2CAP(d): cid 0x0040 len 27 [psm 0]
      0000: 07 00 02 00 16 00 13 6e  64 73 2d 46 72 65 65 20  .......nds-Free 
      0010: 75 6e 69 74 09 03 11 09  00 19 00                 unit.......
2011-09-29 14:03:11.965287 < HCI Command: Authentication Requested (0x01|0x0011) plen 2
    handle 11
2011-09-29 14:03:11.967056 > HCI Event: Command Status (0x0f) plen 4
    Authentication Requested (0x01|0x0011) status 0x00 ncmd 1
2011-09-29 14:03:11.968080 > HCI Event: Link Key Request (0x17) plen 6
    bdaddr 00:0B:E4:A6:6C:0D
2011-09-29 14:03:11.968322 < HCI Command: Link Key Request Reply (0x01|0x000b) plen 22
    bdaddr 00:0B:E4:A6:6C:0D key 08AB2E2A1319F534321C46393A25B42D
2011-09-29 14:03:11.979080 > HCI Event: Command Complete (0x0e) plen 10
    Link Key Request Reply (0x01|0x000b) ncmd 1
    status 0x00 bdaddr 00:0B:E4:A6:6C:0D
2011-09-29 14:03:12.006084 > HCI Event: Auth Complete (0x06) plen 3
    status 0x00 handle 11
2011-09-29 14:03:12.006161 < ACL data: handle 11 flags 0x00 dlen 12
    0000: 08 00 01 00 02 04 04 00  03 00 41 00              ..........A.
2011-09-29 14:03:12.009052 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 11 packets 2
2011-09-29 14:03:12.015065 > ACL data: handle 11 flags 0x02 dlen 16
    L2CAP(s): Connect rsp: dcid 0x0043 scid 0x0041 result 1 status 2
      Connection pending - Authorization pending
2011-09-29 14:03:14.167024 > HCI Event: Disconn Complete (0x05) plen 4
    status 0x00 handle 11 reason 0x05
    Reason: Authentication Failure

--------------000703080002070601080608
Content-Type: text/plain;
 name="v3.1-successful.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="v3.1-successful.txt"

HCI sniffer - Bluetooth packet analyzer ver 2.0
device: hci0 snap_len: 1028 filter: 0xffffffffffffffff
2011-09-29 13:59:22.971462 > HCI Event: Connect Request (0x04) plen 10
    bdaddr 00:0B:E4:A6:6C:0D class 0x240404 type ACL
2011-09-29 13:59:22.971639 < HCI Command: Accept Connection Request (0x01|0x0009) plen 7
    bdaddr 00:0B:E4:A6:6C:0D role 0x00
    Role: Master
2011-09-29 13:59:22.973362 > HCI Event: Command Status (0x0f) plen 4
    Accept Connection Request (0x01|0x0009) status 0x00 ncmd 1
2011-09-29 13:59:23.515454 > HCI Event: Role Change (0x12) plen 8
    status 0x00 bdaddr 00:0B:E4:A6:6C:0D role 0x00
    Role: Master
2011-09-29 13:59:23.783362 > HCI Event: Connect Complete (0x03) plen 11
    status 0x00 handle 12 bdaddr 00:0B:E4:A6:6C:0D type ACL encrypt 0x00
2011-09-29 13:59:23.783681 < HCI Command: Read Remote Supported Features (0x01|0x001b) plen 2
    handle 12
2011-09-29 13:59:23.785359 > HCI Event: Command Status (0x0f) plen 4
    Read Remote Supported Features (0x01|0x001b) status 0x00 ncmd 1
2011-09-29 13:59:23.786352 > HCI Event: Read Remote Supported Features (0x0b) plen 11
    status 0x00 handle 12
    Features: 0xff 0xfe 0x0f 0xc6 0x9b 0xff 0x59 0x83
2011-09-29 13:59:23.786467 < HCI Command: Read Remote Extended Features (0x01|0x001c) plen 3
    handle 12 page 1
2011-09-29 13:59:23.788355 > HCI Event: Command Status (0x0f) plen 4
    Read Remote Extended Features (0x01|0x001c) status 0x00 ncmd 1
2011-09-29 13:59:23.853398 > HCI Event: Max Slots Change (0x1b) plen 3
    handle 12 slots 5
2011-09-29 13:59:24.192436 > HCI Event: Read Remote Extended Features (0x23) plen 13
    status 0x00 handle 12 page 1 max 1
    Features: 0x01 0x00 0x00 0x00 0x00 0x00 0x00 0x00
2011-09-29 13:59:24.192834 < HCI Command: Remote Name Request (0x01|0x0019) plen 10
    bdaddr 00:0B:E4:A6:6C:0D mode 2 clkoffset 0x0000
2011-09-29 13:59:24.194388 > HCI Event: Command Status (0x0f) plen 4
    Remote Name Request (0x01|0x0019) status 0x00 ncmd 1
2011-09-29 13:59:24.261146 > ACL data: handle 12 flags 0x02 dlen 12
    L2CAP(s): Connect req: psm 1 scid 0x0040
2011-09-29 13:59:24.261453 < ACL data: handle 12 flags 0x00 dlen 16
    0000: 0c 00 01 00 03 02 08 00  40 00 40 00 01 00 00 00  ........@.@.....
2011-09-29 13:59:24.261463 < ACL data: handle 12 flags 0x00 dlen 10
    0000: 06 00 01 00 0a 01 02 00  02 00                    ..........
2011-09-29 13:59:24.345420 > HCI Event: Remote Name Req Complete (0x07) plen 255
    status 0x00 bdaddr 00:0B:E4:A6:6C:0D name 'Nokia BH-905i'
2011-09-29 13:59:24.346338 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 12 packets 2
2011-09-29 13:59:24.396251 > ACL data: handle 12 flags 0x02 dlen 16
    L2CAP(s): Info rsp: type 2 result 0
      Extended feature mask 0x0000
2011-09-29 13:59:24.396390 < ACL data: handle 12 flags 0x00 dlen 16
    0000: 0c 00 01 00 03 02 08 00  40 00 40 00 00 00 00 00  ........@.@.....
2011-09-29 13:59:24.396406 < ACL data: handle 12 flags 0x00 dlen 12
    0000: 08 00 01 00 04 02 04 00  40 00 00 00              ........@...
2011-09-29 13:59:24.465349 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 12 packets 2
2011-09-29 13:59:24.531314 > ACL data: handle 12 flags 0x02 dlen 16
    L2CAP(s): Config req: dcid 0x0040 flags 0x00 clen 4
      MTU 48 
2011-09-29 13:59:24.531621 < ACL data: handle 12 flags 0x00 dlen 18
    0000: 0e 00 01 00 05 03 0a 00  40 00 00 00 00 00 01 02  ........@.......
    0010: 30 00                                             0.
2011-09-29 13:59:24.532511 > ACL data: handle 12 flags 0x02 dlen 14
    L2CAP(s): Config rsp: scid 0x0040 flags 0x00 result 0 clen 0
      Success
2011-09-29 13:59:24.668686 > ACL data: handle 12 flags 0x02 dlen 24
    L2CAP(d): cid 0x0040 len 20 [psm 0]
      0000: 06 00 01 00 0f 35 05 1a  00 00 11 1f 00 26 35 03  .....5.......&5.
      0010: 09 00 04 00                                       ....
2011-09-29 13:59:24.669362 < ACL data: handle 12 flags 0x00 dlen 33
    0000: 1d 00 40 00 07 00 01 00  18 00 15 35 13 35 11 09  ..@........5.5..
    0010: 00 04 35 0c 35 03 19 01  00 35 05 19 00 03 08 0d  ..5.5....5......
    0020: 00                                                .
2011-09-29 13:59:24.737436 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 12 packets 2
2011-09-29 13:59:24.804964 > ACL data: handle 12 flags 0x02 dlen 12
    L2CAP(s): Disconn req: dcid 0x0040 scid 0x0040
2011-09-29 13:59:24.805133 < ACL data: handle 12 flags 0x00 dlen 12
    0000: 08 00 01 00 07 04 04 00  40 00 40 00              ........@.@.
2011-09-29 13:59:25.009388 > HCI Event: Link Key Request (0x17) plen 6
    bdaddr 00:0B:E4:A6:6C:0D
2011-09-29 13:59:25.009956 < HCI Command: Link Key Request Reply (0x01|0x000b) plen 22
    bdaddr 00:0B:E4:A6:6C:0D key 08AB2E2A1319F534321C46393A25B42D
2011-09-29 13:59:25.018340 > HCI Event: Command Complete (0x0e) plen 10
    Link Key Request Reply (0x01|0x000b) ncmd 1
    status 0x00 bdaddr 00:0B:E4:A6:6C:0D
2011-09-29 13:59:25.038329 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 12 packets 1
2011-09-29 13:59:25.493371 > HCI Event: Encrypt Change (0x08) plen 4
    status 0x00 handle 12 encrypt 0x01
2011-09-29 13:59:25.494822 > ACL data: handle 12 flags 0x02 dlen 12
    L2CAP(s): Connect req: psm 3 scid 0x0041
2011-09-29 13:59:25.494924 < ACL data: handle 12 flags 0x00 dlen 16
    0000: 0c 00 01 00 03 05 08 00  40 00 41 00 00 00 00 00  ........@.A.....
2011-09-29 13:59:25.494933 < ACL data: handle 12 flags 0x00 dlen 16
    0000: 0c 00 01 00 04 03 08 00  41 00 00 00 01 02 f5 03  ........A.......
2011-09-29 13:59:25.565375 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 12 packets 2
2011-09-29 13:59:25.631295 > ACL data: handle 12 flags 0x02 dlen 16
    L2CAP(s): Config req: dcid 0x0040 flags 0x00 clen 4
      MTU 895 
2011-09-29 13:59:25.631486 < ACL data: handle 12 flags 0x00 dlen 18
    0000: 0e 00 01 00 05 06 0a 00  41 00 00 00 00 00 01 02  ........A.......
    0010: 7f 03                                             ..
2011-09-29 13:59:25.632494 > ACL data: handle 12 flags 0x02 dlen 18
    L2CAP(s): Config rsp: scid 0x0040 flags 0x00 result 0 clen 4
      MTU 1013 
2011-09-29 13:59:25.768792 > ACL data: handle 12 flags 0x02 dlen 8
    L2CAP(d): cid 0x0040 len 4 [psm 0]
      0000: 03 3f 01 1c                                       .?..
2011-09-29 13:59:25.769182 < ACL data: handle 12 flags 0x00 dlen 8
    0000: 04 00 41 00 03 73 01 d7                           ..A..s..
2011-09-29 13:59:25.837378 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 12 packets 2
2011-09-29 13:59:25.903662 > ACL data: handle 12 flags 0x02 dlen 18
    L2CAP(d): cid 0x0040 len 14 [psm 0]
      0000: 03 ef 15 83 11 1a f0 00  00 7e 00 00 00 70        .........~...p
2011-09-29 13:59:25.903961 < ACL data: handle 12 flags 0x00 dlen 18
    0000: 0e 00 41 00 01 ef 15 81  11 1a e0 00 00 7e 00 00  ..A..........~..
    0010: 07 aa                                             ..
2011-09-29 13:59:26.038581 > ACL data: handle 12 flags 0x02 dlen 8
    L2CAP(d): cid 0x0040 len 4 [psm 0]
      0000: 6b 3f 01 e7                                       k?..
2011-09-29 13:59:26.038954 < HCI Command: Authentication Requested (0x01|0x0011) plen 2
    handle 12
2011-09-29 13:59:26.041418 > HCI Event: Command Status (0x0f) plen 4
    Authentication Requested (0x01|0x0011) status 0x00 ncmd 1
2011-09-29 13:59:26.042316 > HCI Event: Link Key Request (0x17) plen 6
    bdaddr 00:0B:E4:A6:6C:0D
2011-09-29 13:59:26.042725 < HCI Command: Link Key Request Reply (0x01|0x000b) plen 22
    bdaddr 00:0B:E4:A6:6C:0D key 08AB2E2A1319F534321C46393A25B42D
2011-09-29 13:59:26.053328 > HCI Event: Command Complete (0x0e) plen 10
    Link Key Request Reply (0x01|0x000b) ncmd 1
    status 0x00 bdaddr 00:0B:E4:A6:6C:0D
2011-09-29 13:59:26.163412 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 12 packets 1
2011-09-29 13:59:26.174328 > HCI Event: Auth Complete (0x06) plen 3
    status 0x00 handle 12
2011-09-29 13:59:26.175519 < ACL data: handle 12 flags 0x00 dlen 8
    0000: 04 00 41 00 6b 73 01 2c                           ..A.ks.,
2011-09-29 13:59:26.175550 < ACL data: handle 12 flags 0x00 dlen 12
    0000: 08 00 41 00 01 ef 09 e3  05 6b 8d aa              ..A......k..
2011-09-29 13:59:26.646333 > HCI Event: Encryption Key Refresh Complete (0x30) plen 3
    status 0x00 handle 12
2011-09-29 13:59:26.715408 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 12 packets 2
2011-09-29 13:59:26.782530 > ACL data: handle 12 flags 0x02 dlen 12
    L2CAP(d): cid 0x0040 len 8 [psm 0]
      0000: 03 ef 09 e1 05 6b 8d 70                           .....k.p
2011-09-29 13:59:26.783631 > ACL data: handle 12 flags 0x02 dlen 12
    L2CAP(d): cid 0x0040 len 8 [psm 0]
      0000: 03 ef 09 e3 05 6b 0d 70                           .....k.p
2011-09-29 13:59:26.783766 < ACL data: handle 12 flags 0x00 dlen 12
    0000: 08 00 41 00 01 ef 09 e1  05 6b 0d aa              ..A......k..
2011-09-29 13:59:26.783792 < ACL data: handle 12 flags 0x00 dlen 9
    0000: 05 00 41 00 69 ff 01 21  22                       ..A.i..!"
2011-09-29 13:59:26.785479 > ACL data: handle 12 flags 0x02 dlen 9
    L2CAP(d): cid 0x0040 len 5 [psm 0]
      0000: 6b ff 01 0f f8                                    k....
2011-09-29 13:59:26.851236 > ACL data: handle 12 flags 0x02 dlen 19
    L2CAP(d): cid 0x0040 len 15 [psm 0]
      0000: 6b ef 17 41 54 2b 42 52  53 46 3d 32 35 0d e4     k..AT+BRSF=25..
2011-09-29 13:59:26.851652 < ACL data: handle 12 flags 0x00 dlen 22
    0000: 12 00 41 00 69 ef 1d 0d  0a 2b 42 52 53 46 3a 20  ..A.i....+BRSF: 
    0010: 33 35 32 0d 0a 3e                                 352..>
2011-09-29 13:59:26.851682 < ACL data: handle 12 flags 0x00 dlen 14
    0000: 0a 00 41 00 69 ef 0d 0d  0a 4f 4b 0d 0a 3e        ..A.i....OK..>
2011-09-29 13:59:26.854408 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 12 packets 2
2011-09-29 13:59:26.920406 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 12 packets 2
2011-09-29 13:59:27.053798 > ACL data: handle 12 flags 0x02 dlen 19
    L2CAP(d): cid 0x0040 len 15 [psm 0]
      0000: 6b ff 15 02 41 54 2b 43  49 4e 44 3d 3f 0d f8     k...AT+CIND=?..
2011-09-29 13:59:27.054372 < ACL data: handle 12 flags 0x00 dlen 134
    0000: 82 00 41 00 69 ef fd 0d  0a 2b 43 49 4e 44 3a 20  ..A.i....+CIND: 
    0010: 28 22 62 61 74 74 63 68  67 22 2c 28 30 2d 35 29  ("battchg",(0-5)
    0020: 29 2c 28 22 73 69 67 6e  61 6c 22 2c 28 30 2d 35  ),("signal",(0-5
    0030: 29 29 2c 28 22 73 65 72  76 69 63 65 22 2c 28 30  )),("service",(0
    0040: 2c 31 29 29 2c 28 22 63  61 6c 6c 22 2c 28 30 2c  ,1)),("call",(0,
    0050: 31 29 29 2c 28 22 63 61  6c 6c 73 65 74 75 70 22  1)),("callsetup"
    0060: 2c 28 30 2d 33 29 29 2c  28 22 63 61 6c 6c 68 65  ,(0-3)),("callhe
    0070: 6c 64 22 2c 28 30 2d 32  29 29 2c 28 22 72 6f 61  ld",(0-2)),("roa
    0080: 6d 22 2c 28 30 3e                                 m",(0>
2011-09-29 13:59:27.054406 < ACL data: handle 12 flags 0x00 dlen 14
    0000: 0a 00 41 00 69 ef 0d 2c  31 29 29 0d 0a 3e        ..A.i..,1))..>
2011-09-29 13:59:27.054422 < ACL data: handle 12 flags 0x00 dlen 14
    0000: 0a 00 41 00 69 ef 0d 0d  0a 4f 4b 0d 0a 3e        ..A.i....OK..>
2011-09-29 13:59:27.124316 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 12 packets 2
2011-09-29 13:59:27.392520 > ACL data: handle 12 flags 0x02 dlen 18
    L2CAP(d): cid 0x0040 len 14 [psm 0]
      0000: 6b ff 13 03 41 54 2b 43  49 4e 44 3f 0d f8        k...AT+CIND?..
2011-09-29 13:59:27.393100 < ACL data: handle 12 flags 0x00 dlen 32
    0000: 1c 00 41 00 69 ef 31 0d  0a 2b 43 49 4e 44 3a 20  ..A.i.1..+CIND: 
    0010: 35 2c 35 2c 31 2c 30 2c  30 2c 30 2c 30 0d 0a 3e  5,5,1,0,0,0,0..>
2011-09-29 13:59:27.393167 < ACL data: handle 12 flags 0x00 dlen 14
    0000: 0a 00 41 00 69 ef 0d 0d  0a 4f 4b 0d 0a 3e        ..A.i....OK..>
2011-09-29 13:59:27.462316 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 12 packets 2
2011-09-29 13:59:27.729928 > ACL data: handle 12 flags 0x02 dlen 28
    L2CAP(d): cid 0x0040 len 24 [psm 0]
      0000: 6b ff 27 02 41 54 2b 43  4d 45 52 3d 33 2c 20 30  k.'.AT+CMER=3, 0
      0010: 2c 20 30 2c 20 31 0d f8                           , 0, 1..
2011-09-29 13:59:27.731058 < ACL data: handle 12 flags 0x00 dlen 14
    0000: 0a 00 41 00 69 ef 0d 0d  0a 4f 4b 0d 0a 3e        ..A.i....OK..>
2011-09-29 13:59:27.798318 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 12 packets 2
2011-09-29 13:59:28.066289 > ACL data: handle 12 flags 0x02 dlen 19
    L2CAP(d): cid 0x0040 len 15 [psm 0]
      0000: 6b ff 15 01 41 54 2b 56  47 53 3d 31 30 0d f8     k...AT+VGS=10..
2011-09-29 13:59:28.067001 < ACL data: handle 12 flags 0x00 dlen 14
    0000: 0a 00 41 00 69 ef 0d 0d  0a 4f 4b 0d 0a 3e        ..A.i....OK..>
2011-09-29 13:59:28.288307 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 12 packets 1
2011-09-29 13:59:28.470030 > ACL data: handle 12 flags 0x02 dlen 12
    L2CAP(s): Connect req: psm 1 scid 0x0042
2011-09-29 13:59:28.470274 < ACL data: handle 12 flags 0x00 dlen 16
    0000: 0c 00 01 00 03 07 08 00  41 00 42 00 00 00 00 00  ........A.B.....
2011-09-29 13:59:28.470283 < ACL data: handle 12 flags 0x00 dlen 12
    0000: 08 00 01 00 04 04 04 00  42 00 00 00              ........B...
2011-09-29 13:59:28.471531 > ACL data: handle 12 flags 0x02 dlen 19
    L2CAP(d): cid 0x0040 len 15 [psm 0]
      0000: 6b ff 15 01 41 54 2b 56  47 4d 3d 31 30 0d f8     k...AT+VGM=10..
2011-09-29 13:59:28.472222 < ACL data: handle 12 flags 0x00 dlen 14
    0000: 0a 00 41 00 69 ef 0d 0d  0a 4f 4b 0d 0a 3e        ..A.i....OK..>
2011-09-29 13:59:28.540407 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 12 packets 2
2011-09-29 13:59:28.607586 > ACL data: handle 12 flags 0x02 dlen 16
    L2CAP(s): Config req: dcid 0x0041 flags 0x00 clen 4
      MTU 48 
2011-09-29 13:59:28.607779 < ACL data: handle 12 flags 0x00 dlen 18
    0000: 0e 00 01 00 05 08 0a 00  42 00 00 00 00 00 01 02  ........B.......
    0010: 30 00                                             0.
2011-09-29 13:59:28.608697 > ACL data: handle 12 flags 0x02 dlen 14
    L2CAP(s): Config rsp: scid 0x0041 flags 0x00 result 0 clen 0
      Success
2011-09-29 13:59:28.660505 < ACL data: handle 12 flags 0x00 dlen 12
    0000: 08 00 01 00 02 05 04 00  19 00 42 00              ..........B.
2011-09-29 13:59:28.667286 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 12 packets 2
2011-09-29 13:59:28.736246 > ACL data: handle 12 flags 0x02 dlen 16
    L2CAP(s): Connect rsp: dcid 0x0043 scid 0x0042 result 1 status 2
      Connection pending - Authorization pending
2011-09-29 13:59:28.737442 > ACL data: handle 12 flags 0x02 dlen 24
    L2CAP(d): cid 0x0041 len 20 [psm 0]
      0000: 06 00 01 00 0f 35 05 1a  00 00 11 1f 00 26 35 03  .....5.......&5.
      0010: 09 00 09 00                                       ....
2011-09-29 13:59:28.737889 < ACL data: handle 12 flags 0x00 dlen 29
    0000: 19 00 42 00 07 00 01 00  14 00 11 35 0f 35 0d 09  ..B........5.5..
    0010: 00 09 35 08 35 06 19 11  1e 09 01 05 00           ..5.5........
2011-09-29 13:59:28.738773 > ACL data: handle 12 flags 0x02 dlen 30
    L2CAP(d): cid 0x0040 len 26 [psm 0]
      0000: 6b ff 2b 01 41 54 2b 43  53 52 53 46 3d 31 2c 31  k.+.AT+CSRSF=1,1
      0010: 2c 31 2c 31 2c 31 2c 37  0d f8                    ,1,1,1,7..
2011-09-29 13:59:28.739223 < ACL data: handle 12 flags 0x00 dlen 17
    0000: 0d 00 41 00 69 ef 13 0d  0a 45 52 52 4f 52 0d 0a  ..A.i....ERROR..
    0010: 3e                                                >
2011-09-29 13:59:28.742380 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 12 packets 2
2011-09-29 13:59:28.811276 > ACL data: handle 12 flags 0x02 dlen 12
    L2CAP(s): Disconn req: dcid 0x0041 scid 0x0042
2011-09-29 13:59:28.811414 < ACL data: handle 12 flags 0x00 dlen 12
    0000: 08 00 01 00 07 09 04 00  41 00 42 00              ........A.B.
2011-09-29 13:59:28.815306 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 12 packets 2
2011-09-29 13:59:28.883675 > ACL data: handle 12 flags 0x02 dlen 16
    L2CAP(s): Connect rsp: dcid 0x0043 scid 0x0042 result 0 status 0
      Connection successful
2011-09-29 13:59:28.883787 < ACL data: handle 12 flags 0x00 dlen 12
    0000: 08 00 01 00 04 06 04 00  43 00 00 00              ........C...
2011-09-29 13:59:28.884907 > ACL data: handle 12 flags 0x02 dlen 16
    L2CAP(s): Config req: dcid 0x0042 flags 0x00 clen 4
      MTU 895 
2011-09-29 13:59:28.885107 < ACL data: handle 12 flags 0x00 dlen 18
    0000: 0e 00 01 00 05 0a 0a 00  43 00 00 00 00 00 01 02  ........C.......
    0010: 7f 03                                             ..
2011-09-29 13:59:28.889299 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 12 packets 2
2011-09-29 13:59:28.956158 > ACL data: handle 12 flags 0x02 dlen 14
    L2CAP(s): Config rsp: scid 0x0042 flags 0x00 result 0 clen 0
      Success
2011-09-29 13:59:28.956657 < ACL data: handle 12 flags 0x00 dlen 12
    0000: 08 00 01 00 02 07 04 00  17 00 41 00              ..........A.
2011-09-29 13:59:28.956714 < ACL data: handle 12 flags 0x00 dlen 6
    0000: 02 00 43 00 e0 01                                 ..C...
2011-09-29 13:59:28.962336 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 12 packets 2
2011-09-29 13:59:29.028705 > ACL data: handle 12 flags 0x02 dlen 16
    L2CAP(s): Connect rsp: dcid 0x0044 scid 0x0041 result 1 status 2
      Connection pending - Authorization pending
2011-09-29 13:59:29.098774 > ACL data: handle 12 flags 0x02 dlen 12
    L2CAP(d): cid 0x0042 len 8 [psm 0]
      0000: e2 01 04 08 08 08 10 08                           ........
2011-09-29 13:59:29.099421 < ACL data: handle 12 flags 0x00 dlen 7
    0000: 03 00 43 00 f0 02 04                              ..C....
2011-09-29 13:59:29.114286 > HCI Event: Inquiry Complete (0x01) plen 1
    status 0x00
2011-09-29 13:59:29.180018 > ACL data: handle 12 flags 0x02 dlen 20
    L2CAP(d): cid 0x0042 len 16 [psm 0]
      0000: f2 02 01 00 07 06 00 00  bf ff 02 35 04 02 02 00  ...........5....
2011-09-29 13:59:29.180625 < ACL data: handle 12 flags 0x00 dlen 7
    0000: 03 00 43 00 00 02 08                              ..C....
2011-09-29 13:59:29.184275 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 12 packets 2
2011-09-29 13:59:29.287590 > ACL data: handle 12 flags 0x02 dlen 20
    L2CAP(d): cid 0x0042 len 16 [psm 0]
      0000: 02 02 01 00 07 06 00 01  3f 07 ff fe 04 02 02 00  ........?.......
2011-09-29 13:59:29.288101 < ACL data: handle 12 flags 0x00 dlen 7
    0000: 03 00 43 00 10 02 10                              ..C....
2011-09-29 13:59:29.369900 > ACL data: handle 12 flags 0x02 dlen 22
    L2CAP(d): cid 0x0042 len 18 [psm 0]
      0000: 12 02 01 00 07 08 00 02  c0 ff fc 90 00 00 04 02  ................
      0010: 02 00                                             ..
2011-09-29 13:59:29.370894 < ACL data: handle 12 flags 0x00 dlen 18
    0000: 0e 00 43 00 20 03 04 04  01 00 07 06 00 00 21 15  ..C. .........!.
    0010: 02 35                                             .5
2011-09-29 13:59:29.374270 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 12 packets 2
2011-09-29 13:59:29.452405 > ACL data: handle 12 flags 0x02 dlen 6
    L2CAP(d): cid 0x0042 len 2 [psm 0]
      0000: 22 03                                             ".
2011-09-29 13:59:29.453101 < ACL data: handle 12 flags 0x00 dlen 7
    0000: 03 00 43 00 30 06 04                              ..C.0..
2011-09-29 13:59:29.510014 > ACL data: handle 12 flags 0x02 dlen 6
    L2CAP(d): cid 0x0042 len 2 [psm 0]
      0000: 32 06                                             2.
2011-09-29 13:59:29.510683 < ACL data: handle 12 flags 0x00 dlen 12
    0000: 08 00 01 00 02 08 04 00  19 00 43 00              ..........C.
2011-09-29 13:59:29.514283 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 12 packets 2
2011-09-29 13:59:29.542489 > ACL data: handle 12 flags 0x02 dlen 16
    L2CAP(s): Connect rsp: dcid 0x0045 scid 0x0043 result 1 status 2
      Connection pending - Authorization pending
2011-09-29 13:59:29.543659 > ACL data: handle 12 flags 0x02 dlen 16
    L2CAP(s): Connect rsp: dcid 0x0044 scid 0x0041 result 0 status 0
      Connection successful
2011-09-29 13:59:29.543875 < ACL data: handle 12 flags 0x00 dlen 12
    0000: 08 00 01 00 04 09 04 00  44 00 00 00              ........D...
2011-09-29 13:59:29.544885 > ACL data: handle 12 flags 0x02 dlen 16
    L2CAP(s): Config req: dcid 0x0041 flags 0x00 clen 4
      MTU 895 
2011-09-29 13:59:29.545008 < ACL data: handle 12 flags 0x00 dlen 18
    0000: 0e 00 01 00 05 0b 0a 00  44 00 00 00 00 00 01 02  ........D.......
    0010: 7f 03                                             ..
2011-09-29 13:59:29.549268 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 12 packets 2
2011-09-29 13:59:29.602516 > ACL data: handle 12 flags 0x02 dlen 14
    L2CAP(s): Config rsp: scid 0x0041 flags 0x00 result 0 clen 0
      Success
2011-09-29 13:59:30.067464 > ACL data: handle 12 flags 0x02 dlen 16
    L2CAP(s): Connect rsp: dcid 0x0045 scid 0x0043 result 0 status 0
      Connection successful
2011-09-29 13:59:30.067868 < ACL data: handle 12 flags 0x00 dlen 12
    0000: 08 00 01 00 04 0a 04 00  45 00 00 00              ........E...
2011-09-29 13:59:30.068804 > ACL data: handle 12 flags 0x02 dlen 16
    L2CAP(s): Config req: dcid 0x0043 flags 0x00 clen 4
      MTU 895 
2011-09-29 13:59:30.068992 < ACL data: handle 12 flags 0x00 dlen 18
    0000: 0e 00 01 00 05 0c 0a 00  45 00 00 00 00 00 01 02  ........E.......
    0010: 7f 03                                             ..
2011-09-29 13:59:30.073327 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 12 packets 2
2011-09-29 13:59:30.112480 > ACL data: handle 12 flags 0x02 dlen 14
    L2CAP(s): Config rsp: scid 0x0043 flags 0x00 result 0 clen 0
      Success
2011-09-29 13:59:30.139095 < ACL data: handle 12 flags 0x00 dlen 7
    0000: 03 00 43 00 40 07 04                              ..C.@..
2011-09-29 13:59:30.218650 > ACL data: handle 12 flags 0x02 dlen 6
    L2CAP(d): cid 0x0042 len 2 [psm 0]
      0000: 42 07                                             B.
2011-09-29 13:59:30.220117 < ACL data: handle 12 flags 0x00 dlen 850
    0000: 4e 03 45 00 80 01 00 00  00 00 00 00 00 00 00 01  N.E.............
    0010: 07 9c bd 35 7d 00 00 00  00 00 00 00 00 00 77 76  ...5}.........wv
    0020: db 6e ed b6 db bb b6 db  77 6d b6 dd dd b6 db bb  .n......wm......
    0030: 6d b6 ee ed b6 dd db 6d  b7 77 6d b6 ee db 6d bb  m......m.wm...m.
    0040: bb 6d b7 76 db 6d dd db  6d bb b6 db 6e ee db 6d  .m.v.m..m...n..m
    0050: dd b6 db 77 76 db 6e ed  b6 db bb b6 db 77 6d b6  ...wv.n......wm.
    0060: dd dd b6 db bb 6d b6 ee  ed b6 dd db 6d b7 77 6d  .....m......m.wm
    0070: b6 ee db 6d bb bb 6d b7  76 db 6d dd db 6d bb b6  ...m..m.v.m..m..
    0080: db 6e ee db 6d dd b6 db  9c bd 35 7d 00 00 00 00  .n..m.....5}....
    0090: 00 00 00 00 00 77 76 db  6e ed b6 db bb b6 db 77  .....wv.n......w
    00a0: 6d b6 dd dd b6 db bb 6d  b6 ee ed b6 dd db 6d b7  m......m......m.
    00b0: 77 6d b6 ee db 6d bb bb  6d b7 76 db 6d dd db 6d  wm...m..m.v.m..m
    00c0: bb b6 db 6e ee db 6d dd  b6 db 77 76 db 6e ed b6  ...n..m...wv.n..
    00d0: db bb b6 db 77 6d b6 dd  dd b6 db bb 6d b6 ee ed  ....wm......m...
    00e0: b6 dd db 6d b7 77 6d b6  ee db 6d bb bb 6d b7 76  ...m.wm...m..m.v
    00f0: db 6d dd db 6d bb b6 db  6e ee db 6d dd b6 db 9c  .m..m...n..m....
    0100: bd 35 7d 00 00 00 00 00  00 00 00 00 77 76 db 6e  .5}.........wv.n
    0110: ed b6 db bb b6 db 77 6d  b6 dd dd b6 db bb 6d b6  ......wm......m.
    0120: ee ed b6 dd db 6d b7 77  6d b6 ee db 6d bb bb 6d  .....m.wm...m..m
    0130: b7 76 db 6d dd db 6d bb  b6 db 6e ee db 6d dd b6  .v.m..m...n..m..
    0140: db 77 76 db 6e ed b6 db  bb b6 db 77 6d b6 dd dd  .wv.n......wm...
    0150: b6 db bb 6d b6 ee ed b6  dd db 6d b7 77 6d b6 ee  ...m......m.wm..
    0160: db 6d bb bb 6d b7 76 db  6d dd db 6d bb b6 db 6e  .m..m.v.m..m...n
    0170: ee db 6d dd b6 db 9c bd  35 7d 00 00 00 00 00 00  ..m.....5}......
    0180: 00 00 00 77 76 db 6e ed  b6 db bb b6 db 77 6d b6  ...wv.n......wm.
    0190: dd dd b6 db bb 6d b6 ee  ed b6 dd db 6d b7 77 6d  .....m......m.wm
    01a0: b6 ee db 6d bb bb 6d b7  76 db 6d dd db 6d bb b6  ...m..m.v.m..m..
    01b0: db 6e ee db 6d dd b6 db  77 76 db 6e ed b6 db bb  .n..m...wv.n....
    01c0: b6 db 77 6d b6 dd dd b6  db bb 6d b6 ee ed b6 dd  ..wm......m.....
    01d0: db 6d b7 77 6d b6 ee db  6d bb bb 6d b7 76 db 6d  .m.wm...m..m.v.m
    01e0: dd db 6d bb b6 db 6e ee  db 6d dd b6 db 9c bd 35  ..m...n..m.....5
    01f0: 7d 00 00 00 00 00 00 00  00 00 77 76 db 6e ed b6  }.........wv.n..
    0200: db bb b6 db 77 6d b6 dd  dd b6 db bb 6d b6 ee ed  ....wm......m...
    0210: b6 dd db 6d b7 77 6d b6  ee db 6d bb bb 6d b7 76  ...m.wm...m..m.v
    0220: db 6d dd db 6d bb b6 db  6e ee db 6d dd b6 db 77  .m..m...n..m...w
    0230: 76 db 6e ed b6 db bb b6  db 77 6d b6 dd dd b6 db  v.n......wm.....
    0240: bb 6d b6 ee ed b6 dd db  6d b7 77 6d b6 ee db 6d  .m......m.wm...m
    0250: bb bb 6d b7 76 db 6d dd  db 6d bb b6 db 6e ee db  ..m.v.m..m...n..
    0260: 6d dd b6 db 9c bd 35 7d  00 00 00 00 00 00 00 00  m.....5}........
    0270: 00 77 76 db 6e ed b6 db  bb b6 db 77 6d b6 dd dd  .wv.n......wm...
    0280: b6 db bb 6d b6 ee ed b6  dd db 6d b7 77 6d b6 ee  ...m......m.wm..
    0290: db 6d bb bb 6d b7 76 db  6d dd db 6d bb b6 db 6e  .m..m.v.m..m...n
    02a0: ee db 6d dd b6 db 77 76  db 6e ed b6 db bb b6 db  ..m...wv.n......
    02b0: 77 6d b6 dd dd b6 db bb  6d b6 ee ed b6 dd db 6d  wm......m......m
    02c0: b7 77 6d b6 ee db 6d bb  bb 6d b7 76 db 6d dd db  .wm...m..m.v.m..
    02d0: 6d bb b6 db 6e ee db 6d  dd b6 db 9c bd 35 7d 00  m...n..m.....5}.
    02e0: 00 00 00 00 00 00 00 00  77 76 db 6e ed b6 db bb  ........wv.n....
    02f0: b6 db 77 6d b6 dd dd b6  db bb 6d b6 ee ed b6 dd  ..wm......m.....
    0300: db 6d b7 77 6d b6 ee db  6d bb bb 6d b7 76 db 6d  .m.wm...m..m.v.m
    0310: dd db 6d bb b6 db 6e ee  db 6d dd b6 db 77 76 db  ..m...n..m...wv.
    0320: 6e ed b6 db bb b6 db 77  6d b6 dd dd b6 db bb 6d  n......wm......m
    0330: b6 ee ed b6 dd db 6d b7  77 6d b6 ee db 6d bb bb  ......m.wm...m..
    0340: 6d b7 76 db 6d dd db 6d  bb b6 db 6e ee db 6d dd  m.v.m..m...n..m.
    0350: b6 db                                             ..
2011-09-29 13:59:30.227250 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 12 packets 2
2011-09-29 13:59:30.240384 < ACL data: handle 12 flags 0x00 dlen 850
    0000: 4e 03 45 00 80 01 00 01  00 00 03 80 00 00 00 01  N.E.............
    0010: 07 9c bd 35 7d 00 00 00  00 00 00 00 00 00 77 76  ...5}.........wv
    0020: db 6e ed b6 db bb b6 db  77 6d b6 dd dd b6 db bb  .n......wm......
    0030: 6d b6 ee ed b6 dd db 6d  b7 77 6d b6 ee db 6d bb  m......m.wm...m.
    0040: bb 6d b7 76 db 6d dd db  6d bb b6 db 6e ee db 6d  .m.v.m..m...n..m
    0050: dd b6 db 77 76 db 6e ed  b6 db bb b6 db 77 6d b6  ...wv.n......wm.
    0060: dd dd b6 db bb 6d b6 ee  ed b6 dd db 6d b7 77 6d  .....m......m.wm
    0070: b6 ee db 6d bb bb 6d b7  76 db 6d dd db 6d bb b6  ...m..m.v.m..m..
    0080: db 6e ee db 6d dd b6 db  9c bd 35 7d 00 00 00 00  .n..m.....5}....
    0090: 00 00 00 00 00 77 76 db  6e ed b6 db bb b6 db 77  .....wv.n......w
    00a0: 6d b6 dd dd b6 db bb 6d  b6 ee ed b6 dd db 6d b7  m......m......m.
    00b0: 77 6d b6 ee db 6d bb bb  6d b7 76 db 6d dd db 6d  wm...m..m.v.m..m
    00c0: bb b6 db 6e ee db 6d dd  b6 db 77 76 db 6e ed b6  ...n..m...wv.n..
    00d0: db bb b6 db 77 6d b6 dd  dd b6 db bb 6d b6 ee ed  ....wm......m...
    00e0: b6 dd db 6d b7 77 6d b6  ee db 6d bb bb 6d b7 76  ...m.wm...m..m.v
    00f0: db 6d dd db 6d bb b6 db  6e ee db 6d dd b6 db 9c  .m..m...n..m....
    0100: bd 35 7d 00 00 00 00 00  00 00 00 00 77 76 db 6e  .5}.........wv.n
    0110: ed b6 db bb b6 db 77 6d  b6 dd dd b6 db bb 6d b6  ......wm......m.
    0120: ee ed b6 dd db 6d b7 77  6d b6 ee db 6d bb bb 6d  .....m.wm...m..m
    0130: b7 76 db 6d dd db 6d bb  b6 db 6e ee db 6d dd b6  .v.m..m...n..m..
    0140: db 77 76 db 6e ed b6 db  bb b6 db 77 6d b6 dd dd  .wv.n......wm...
    0150: b6 db bb 6d b6 ee ed b6  dd db 6d b7 77 6d b6 ee  ...m......m.wm..
    0160: db 6d bb bb 6d b7 76 db  6d dd db 6d bb b6 db 6e  .m..m.v.m..m...n
    0170: ee db 6d dd b6 db 9c bd  35 7d 00 00 00 00 00 00  ..m.....5}......
    0180: 00 00 00 77 76 db 6e ed  b6 db bb b6 db 77 6d b6  ...wv.n......wm.
    0190: dd dd b6 db bb 6d b6 ee  ed b6 dd db 6d b7 77 6d  .....m......m.wm
    01a0: b6 ee db 6d bb bb 6d b7  76 db 6d dd db 6d bb b6  ...m..m.v.m..m..
    01b0: db 6e ee db 6d dd b6 db  77 76 db 6e ed b6 db bb  .n..m...wv.n....
    01c0: b6 db 77 6d b6 dd dd b6  db bb 6d b6 ee ed b6 dd  ..wm......m.....
    01d0: db 6d b7 77 6d b6 ee db  6d bb bb 6d b7 76 db 6d  .m.wm...m..m.v.m
    01e0: dd db 6d bb b6 db 6e ee  db 6d dd b6 db 9c bd 35  ..m...n..m.....5
    01f0: 7d 00 00 00 00 00 00 00  00 00 77 76 db 6e ed b6  }.........wv.n..
    0200: db bb b6 db 77 6d b6 dd  dd b6 db bb 6d b6 ee ed  ....wm......m...
    0210: b6 dd db 6d b7 77 6d b6  ee db 6d bb bb 6d b7 76  ...m.wm...m..m.v
    0220: db 6d dd db 6d bb b6 db  6e ee db 6d dd b6 db 77  .m..m...n..m...w
    0230: 76 db 6e ed b6 db bb b6  db 77 6d b6 dd dd b6 db  v.n......wm.....
    0240: bb 6d b6 ee ed b6 dd db  6d b7 77 6d b6 ee db 6d  .m......m.wm...m
    0250: bb bb 6d b7 76 db 6d dd  db 6d bb b6 db 6e ee db  ..m.v.m..m...n..
    0260: 6d dd b6 db 9c bd 35 7d  00 00 00 00 00 00 00 00  m.....5}........
    0270: 00 77 76 db 6e ed b6 db  bb b6 db 77 6d b6 dd dd  .wv.n......wm...
    0280: b6 db bb 6d b6 ee ed b6  dd db 6d b7 77 6d b6 ee  ...m......m.wm..
    0290: db 6d bb bb 6d b7 76 db  6d dd db 6d bb b6 db 6e  .m..m.v.m..m...n
    02a0: ee db 6d dd b6 db 77 76  db 6e ed b6 db bb b6 db  ..m...wv.n......
    02b0: 77 6d b6 dd dd b6 db bb  6d b6 ee ed b6 dd db 6d  wm......m......m
    02c0: b7 77 6d b6 ee db 6d bb  bb 6d b7 76 db 6d dd db  .wm...m..m.v.m..
    02d0: 6d bb b6 db 6e ee db 6d  dd b6 db 9c bd 35 7d 00  m...n..m.....5}.
    02e0: 00 00 00 00 00 00 00 00  77 76 db 6e ed b6 db bb  ........wv.n....
    02f0: b6 db 77 6d b6 dd dd b6  db bb 6d b6 ee ed b6 dd  ..wm......m.....
    0300: db 6d b7 77 6d b6 ee db  6d bb bb 6d b7 76 db 6d  .m.wm...m..m.v.m
    0310: dd db 6d bb b6 db 6e ee  db 6d dd b6 db 77 76 db  ..m...n..m...wv.
    0320: 6e ed b6 db bb b6 db 77  6d b6 dd dd b6 db bb 6d  n......wm......m
    0330: b6 ee ed b6 dd db 6d b7  77 6d b6 ee db 6d bb bb  ......m.wm...m..
    0340: 6d b7 76 db 6d dd db 6d  bb b6 db 6e ee db 6d dd  m.v.m..m...n..m.
    0350: b6 db                                             ..
[...]

--------------000703080002070601080608--
