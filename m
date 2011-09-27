Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab1I1AZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 20:25:07 -0400
Received: from claw.goop.org ([74.207.240.146]:36167 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207Ab1I1AZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 20:25:04 -0400
Message-ID: <4E820FD8.2030907@goop.org>
Date: Tue, 27 Sep 2011 11:03:04 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: padovan@profusion.mobi
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org,
        Keith Packard <keithp@keithp.com>
Subject: Re: Bluetooth regression with headphones
References: <4E6EB2DE.8090102@goop.org> <4E73CEB5.9090406@goop.org> <4E73CFEF.5000509@goop.org>
In-Reply-To: <4E73CFEF.5000509@goop.org>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

On 09/16/2011 03:38 PM, Jeremy Fitzhardinge wrote:
> On 09/16/2011 03:33 PM, Jeremy Fitzhardinge wrote:
>> On 09/12/2011 06:33 PM, Jeremy Fitzhardinge wrote:
>>> Hi all,
>>>
>>> I reported a regression in connecting my Nokia BH-905i headphones in
>>> June this year (https://lkml.org/lkml/2011/6/23/770), which was the same
>>> problem Keith Packard reported in https://lkml.org/lkml/2011/6/9/63.  
>>> It was briefly fixed in
>>> git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git.
>>>
>>> Unfortunately it regressed again by the time of the linux-3.0 release,
>>> to something with similar symptoms: the headphones won't reliably
>>> connect to my laptop unless I freshly re-pair them.  However, unlike the
>>> original bug, they will very occasionally connect normally, though I
>>> don't know why.
>>>
>>> This behaviour has been consistent since 3.0 up until the current
>>> 3.1-rc6 kernel.
>>>
>>> What further information can I provide?  How can I help debug this?
>> I turned on debugging by running "bluetoothd -n -d", and got the
>> following when trying to connect my headphones:
>>
>> Sep 16 15:30:47 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:headset_set_state() State changed /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D: HEADSET_STATE_DISCONNECTED -> HEADSET_STATE_CONNECTING
>> Sep 16 15:30:47 saboo bluetoothd[22025]: bluetoothd[22025]: src/adapter.c:adapter_get_device() 00:0B:E4:A6:6C:0D
>> Sep 16 15:30:47 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:remote_features_information() hci0 status 0
>> Sep 16 15:30:48 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:remote_name_information() hci0 status 0
>> Sep 16 15:30:48 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:headset_set_channel() Discovered Handsfree service on channel 1
>> Sep 16 15:30:48 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:rfcomm_connect() /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D: Connecting to 00:0B:E4:A6:6C:0D channel 1
>> Sep 16 15:30:48 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:link_key_request() hci0 dba 00:0B:E4:A6:6C:0D
>> Sep 16 15:30:48 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:link_key_request() kernel auth requirements = 0x04
>> Sep 16 15:30:48 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:link_key_request() Matching key found
>> Sep 16 15:30:48 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:link_key_request() link key type 0x04
>> Sep 16 15:30:48 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:auth_complete() hci0 status 0
>> Sep 16 15:30:48 saboo bluetoothd[22025]: bluetoothd[22025]: src/event.c:btd_event_bonding_process_complete() status=00
>> Sep 16 15:30:48 saboo bluetoothd[22025]: bluetoothd[22025]: src/adapter.c:adapter_get_device() 00:0B:E4:A6:6C:0D
>> Sep 16 15:30:48 saboo bluetoothd[22025]: bluetoothd[22025]: src/event.c:btd_event_bonding_process_complete() no pending auth request
>> Sep 16 15:30:50 saboo bluetoothd[22025]: bluetoothd[22025]: Permission denied (13)
>> Sep 16 15:30:50 saboo bluetoothd[22025]: Permission denied (13)
>> Sep 16 15:30:50 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:headset_set_state() State changed /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D: HEADSET_STATE_CONNECTING -> HEADSET_STATE_DISCONNECTED
>> Sep 16 15:30:50 saboo bluetoothd[22025]: bluetoothd[22025]: src/adapter.c:adapter_get_device() 00:0B:E4:A6:6C:0D
>>
> And I get this when I successfully re-pair and connect the headphones:
>
> Sep 16 15:36:30 saboo bluetoothd[22025]: Discovery session 0x7f1059478630 with :1.326 activated
> Sep 16 15:36:30 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:hciops_start_inquiry() hci0 length 8 periodic 1
> Sep 16 15:36:30 saboo bluetoothd[22025]: bluetoothd[22025]: Discovery session 0x7f1059478630 with :1.326 activated
> Sep 16 15:36:30 saboo bluetoothd[22025]: bluetoothd[22025]: src/adapter.c:session_ref() 0x7f1059478630: ref=1
> Sep 16 15:36:35 saboo bluetoothd[22025]: bluetoothd[22025]: src/adapter.c:session_unref() 0x7f1059478630: ref=0
> Sep 16 15:36:35 saboo bluetoothd[22025]: bluetoothd[22025]: src/adapter.c:session_remove() Discovery session 0x7f1059478630 with :1.326 deactivated
> Sep 16 15:36:35 saboo bluetoothd[22025]: bluetoothd[22025]: src/adapter.c:session_remove() Stopping discovery
> Sep 16 15:36:35 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:hciops_stop_inquiry() hci0
> Sep 16 15:36:35 saboo bluetoothd[22025]: Stopping discovery
> Sep 16 15:36:35 saboo bluetoothd[22025]: bluetoothd[22025]: Stopping discovery
> Sep 16 15:36:35 saboo bluetoothd[22025]: Inquiry Failed with status 0x12
> Sep 16 15:36:35 saboo bluetoothd[22025]: bluetoothd[22025]: Inquiry Failed with status 0x12
> Sep 16 15:36:35 saboo bluetoothd[22025]: bluetoothd[22025]: src/adapter.c:adapter_create_device() 00:0B:E4:A6:6C:0D
> Sep 16 15:36:35 saboo bluetoothd[22025]: bluetoothd[22025]: src/device.c:device_create() Creating device /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D
> Sep 16 15:36:35 saboo bluetoothd[22025]: bluetoothd[22025]: src/device.c:btd_device_ref() 0x7f105947ef70: ref=1
> Sep 16 15:36:35 saboo bluetoothd[22025]: bluetoothd[22025]: src/device.c:bonding_request_new() Requesting bonding for 00:0B:E4:A6:6C:0D
> Sep 16 15:36:35 saboo bluetoothd[22025]: bluetoothd[22025]: src/device.c:bonding_request_new() Temporary agent registered for 00:0B:E4:A6:6C:0D at :1.326:/org/bluez/agent/wizard
> Sep 16 15:36:42 saboo bluetoothd[22025]: bluetoothd[22025]: src/adapter.c:adapter_get_device() 00:0B:E4:A6:6C:0D
> Sep 16 15:36:42 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:remote_features_information() hci0 status 0
> Sep 16 15:36:42 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:remote_name_information() hci0 status 0
> Sep 16 15:36:42 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:link_key_request() hci0 dba 00:0B:E4:A6:6C:0D
> Sep 16 15:36:42 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:link_key_request() kernel auth requirements = 0x03
> Sep 16 15:36:42 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:link_key_request() Matching key not found
> Sep 16 15:36:42 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:io_capa_request() hci0 IO capability request for 00:0B:E4:A6:6C:0D
> Sep 16 15:36:42 saboo bluetoothd[22025]: bluetoothd[22025]: src/adapter.c:adapter_get_device() 00:0B:E4:A6:6C:0D
> Sep 16 15:36:42 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:hciops_get_auth_info() hci0 dba 00:0B:E4:A6:6C:0D
> Sep 16 15:36:42 saboo bluetoothd[22025]: bluetoothd[22025]: src/event.c:btd_event_get_io_cap() initial authentication requirement is 0x03
> Sep 16 15:36:42 saboo bluetoothd[22025]: bluetoothd[22025]: src/event.c:btd_event_get_io_cap() final authentication requirement is 0x03
> Sep 16 15:36:44 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:io_capa_response() hci0 IO capability response from 00:0B:E4:A6:6C:0D
> Sep 16 15:36:44 saboo bluetoothd[22025]: bluetoothd[22025]: src/adapter.c:adapter_get_device() 00:0B:E4:A6:6C:0D
> Sep 16 15:36:46 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:user_confirm_request() hci0
> Sep 16 15:36:46 saboo bluetoothd[22025]: bluetoothd[22025]: src/adapter.c:adapter_get_device() 00:0B:E4:A6:6C:0D
> Sep 16 15:36:46 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:hciops_get_auth_info() hci0 dba 00:0B:E4:A6:6C:0D
> Sep 16 15:36:46 saboo bluetoothd[22025]: bluetoothd[22025]: src/event.c:btd_event_user_confirm() confirm IO capabilities are 0x01
> Sep 16 15:36:46 saboo bluetoothd[22025]: bluetoothd[22025]: src/event.c:btd_event_user_confirm() confirm authentication requirement is 0x03
> Sep 16 15:36:46 saboo bluetoothd[22025]: bluetoothd[22025]: src/event.c:btd_event_user_confirm() remote IO capabilities are 0x03
> Sep 16 15:36:46 saboo bluetoothd[22025]: bluetoothd[22025]: src/event.c:btd_event_user_confirm() remote authentication requirement is 0x02
> Sep 16 15:36:46 saboo bluetoothd[22025]: bluetoothd[22025]: src/event.c:btd_event_user_confirm() auto accept of confirmation
> Sep 16 15:36:46 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:hciops_confirm_reply() hci0 dba 00:0B:E4:A6:6C:0D success 1
> Sep 16 15:36:46 saboo bluetoothd[22025]: bluetoothd[22025]: src/device.c:device_request_authentication() Requesting agent authentication for 00:0B:E4:A6:6C:0D
> Sep 16 15:36:49 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:simple_pairing_complete() hci0 status 0
> Sep 16 15:36:49 saboo bluetoothd[22025]: bluetoothd[22025]: src/event.c:btd_event_simple_pairing_complete() status=00
> Sep 16 15:36:49 saboo bluetoothd[22025]: bluetoothd[22025]: src/adapter.c:adapter_get_device() 00:0B:E4:A6:6C:0D
> Sep 16 15:36:49 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:link_key_notify() hci0 dba 00:0B:E4:A6:6C:0D type 4
> Sep 16 15:36:49 saboo bluetoothd[22025]: bluetoothd[22025]: src/adapter.c:adapter_get_device() 00:0B:E4:A6:6C:0D
> Sep 16 15:36:49 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:hciops_get_auth_info() hci0 dba 00:0B:E4:A6:6C:0D
> Sep 16 15:36:49 saboo bluetoothd[22025]: bluetoothd[22025]: src/event.c:btd_event_link_key_notify() key type 0x04 old key type 0xff new key type 0x04
> Sep 16 15:36:49 saboo bluetoothd[22025]: bluetoothd[22025]: src/event.c:btd_event_link_key_notify() local auth 0x03 and remote auth 0x02
> Sep 16 15:36:49 saboo bluetoothd[22025]: bluetoothd[22025]: src/event.c:btd_event_link_key_notify() storing link key of type 0x04
> Sep 16 15:36:49 saboo bluetoothd[22025]: bluetoothd[22025]: plugins/hciops.c:auth_complete() hci0 status 0
> Sep 16 15:36:49 saboo bluetoothd[22025]: bluetoothd[22025]: src/event.c:btd_event_bonding_process_complete() status=00
> Sep 16 15:36:49 saboo bluetoothd[22025]: bluetoothd[22025]: src/adapter.c:adapter_get_device() 00:0B:E4:A6:6C:0D
> Sep 16 15:36:49 saboo bluetoothd[22025]: bluetoothd[22025]: src/device.c:btd_device_ref() 0x7f105947ef70: ref=2
> Sep 16 15:36:49 saboo bluetoothd[22025]: bluetoothd[22025]: src/agent.c:agent_release() Releasing agent :1.326, /org/bluez/agent/wizard
> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: src/device.c:device_probe_drivers() Probing drivers for 00:0B:E4:A6:6C:0D
> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: serial/manager.c:serial_probe() path /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D: 0000111e-0000-1000-8000-00805f9b34fb
> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: serial/port.c:create_serial_device() Registered interface org.bluez.Serial on path /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D
> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: serial/manager.c:serial_probe() path /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D: 00001108-0000-1000-8000-00805f9b34fb
> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: input/manager.c:headset_probe() path /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D
> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: src/device.c:btd_device_ref() 0x7f105947ef70: ref=3
> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: input/device.c:input_device_new() Registered interface org.bluez.Input on path /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D
> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: src/adapter.c:adapter_get_device() 00:0B:E4:A6:6C:0D
> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: src/device.c:btd_device_ref() 0x7f105947ef70: ref=4
> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: audio/device.c:audio_device_register() Registered interface org.bluez.Audio on path /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D
> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: audio/manager.c:handle_uuid() Found Headset record
> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:headset_init() Registered interface org.bluez.Headset on path /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D
> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: audio/manager.c:handle_uuid() Found Handsfree record
> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: audio/manager.c:handle_uuid() Found Audio Sink
> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: audio/sink.c:sink_init() Registered interface org.bluez.AudioSink on path /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D
> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: audio/manager.c:handle_uuid() Found AV Target
> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: audio/control.c:control_init() Registered interface org.bluez.Control on path /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D
> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: audio/manager.c:handle_uuid() Found AV Remote
> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: src/device.c:btd_device_unref() 0x7f105947ef70: ref=3
> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:headset_set_state() State changed /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D: HEADSET_STATE_DISCONNECTED -> HEADSET_STATE_CONNECTING
> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:headset_set_channel() Discovered Handsfree service on channel 1
> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:rfcomm_connect() /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D: Connecting to 00:0B:E4:A6:6C:0D channel 1
> Sep 16 15:36:50 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:headset_connect_cb() /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D: Connected to 00:0B:E4:A6:6C:0D
> Sep 16 15:36:51 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:handle_event() Received AT+BRSF=25
> Sep 16 15:36:51 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:print_hf_features() HFP HF features: "EC and/or NR function" "Voice recognition activation" "Remote volume control"
> Sep 16 15:36:51 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:handle_event() Received AT+CIND=?
> Sep 16 15:36:51 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:handle_event() Received AT+CIND?
> Sep 16 15:36:51 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:handle_event() Received AT+CMER=3, 0, 0, 1
> Sep 16 15:36:51 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:event_reporting() Event reporting (CMER): mode=3, ind=1
> Sep 16 15:36:51 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:hfp_slc_complete() HFP Service Level Connection established
> Sep 16 15:36:51 saboo bluetoothd[22025]: bluetoothd[22025]: audio/telephony.c:telephony_device_connected() telephony-dummy: device 0x7f1059492390 connected
> Sep 16 15:36:51 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:headset_set_state() State changed /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D: HEADSET_STATE_CONNECTING -> HEADSET_STATE_CONNECTED
> Sep 16 15:36:52 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:handle_event() Received AT+VGS=10
> Sep 16 15:36:52 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:handle_event() Received AT+VGM=10
> Sep 16 15:36:52 saboo bluetoothd[22025]: Badly formated or unrecognized command: AT+CSRSF=1,1,1,1,1,7
> Sep 16 15:36:52 saboo bluetoothd[22025]: bluetoothd[22025]: audio/headset.c:handle_event() Received AT+CSRSF=1,1,1,1,1,7
> Sep 16 15:36:52 saboo bluetoothd[22025]: bluetoothd[22025]: Badly formated or unrecognized command: AT+CSRSF=1,1,1,1,1,7
> Sep 16 15:36:53 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_ref() 0x7f105947b330: ref=2
> Sep 16 15:36:53 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_ref() 0x7f105947b330: ref=3
> Sep 16 15:36:53 saboo bluetoothd[22025]: bluetoothd[22025]: audio/sink.c:sink_set_state() State changed /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D: SINK_STATE_DISCONNECTED -> SINK_STATE_CONNECTING
> Sep 16 15:36:53 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_unref() 0x7f105947b330: ref=2
> Sep 16 15:36:53 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_connect_cb() AVDTP: connected signaling channel to 00:0B:E4:A6:6C:0D
> Sep 16 15:36:53 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_connect_cb() AVDTP imtu=672, omtu=895
> Sep 16 15:36:53 saboo bluetoothd[22025]: bluetoothd[22025]: audio/control.c:avctp_set_state() AVCTP Connecting
> Sep 16 15:36:53 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:session_cb()
> Sep 16 15:36:53 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_parse_resp() DISCOVER request succeeded
> Sep 16 15:36:53 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_discover_resp() seid 1 type 1 media 0 in use 0
> Sep 16 15:36:53 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_discover_resp() seid 2 type 1 media 0 in use 0
> Sep 16 15:36:53 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_discover_resp() seid 4 type 1 media 0 in use 0
> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:session_cb()
> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_parse_resp() GET_CAPABILITIES request succeeded
> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_get_capabilities_resp() seid 1 type 1 media 0
> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:session_cb()
> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_parse_resp() GET_CAPABILITIES request succeeded
> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_get_capabilities_resp() seid 2 type 1 media 0
> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:session_cb()
> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_parse_resp() GET_CAPABILITIES request succeeded
> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_get_capabilities_resp() seid 4 type 1 media 0
> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/sink.c:discovery_complete() Discovery complete
> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_ref() 0x7f105947b330: ref=3
> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/a2dp.c:setup_ref() 0x7f105947e3f0: ref=1
> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/a2dp.c:a2dp_config() a2dp_config: selected SEP 0x7f1059476ad0
> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/a2dp.c:setup_ref() 0x7f105947e3f0: ref=2
> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_set_configuration() 0x7f105947b330: int_seid=1, acp_seid=1
> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/a2dp.c:setup_unref() 0x7f105947e3f0: ref=1
> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:session_cb()
> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_parse_resp() SET_CONFIGURATION request succeeded
> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/a2dp.c:setconf_cfm() Source 0x7f1059476ad0: Set_Configuration_Cfm
> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_sep_set_state() stream state changed: IDLE -> CONFIGURED
> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/control.c:avctp_connect_cb() AVCTP: connected to 00:0B:E4:A6:6C:0D
> Sep 16 15:36:54 saboo kernel: [93473.952314] input: 00:0B:E4:A6:6C:0D as /devices/virtual/input/input31
> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/control.c:init_uinput() AVRCP: uinput initialized for 00:0B:E4:A6:6C:0D
> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/control.c:avctp_set_state() AVCTP Connected
> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:session_cb()
> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_parse_resp() OPEN request succeeded
> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_connect_cb() AVDTP: connected transport channel to 00:0B:E4:A6:6C:0D
> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:handle_transport_connect() sk 29, omtu 895, send buffer size 63488
> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/a2dp.c:open_cfm() Source 0x7f1059476ad0: Open_Cfm
> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/sink.c:stream_setup_complete() Stream successfully created
> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/a2dp.c:setup_unref() 0x7f105947e3f0: ref=0
> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/a2dp.c:setup_free() 0x7f105947e3f0
> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_unref() 0x7f105947b330: ref=2
> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_sep_set_state() stream state changed: CONFIGURED -> OPEN
> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/sink.c:sink_set_state() State changed /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D: SINK_STATE_CONNECTING -> SINK_STATE_CONNECTED
> Sep 16 15:36:54 saboo bluetoothd[22025]: bluetoothd[22025]: audio/unix.c:server_cb() Accepted new client connection on unix socket (fd=30)
> Sep 16 15:36:54 saboo rsyslogd-2177: imuxsock begins to drop messages from pid 22025 due to rate-limiting
> Sep 16 22:36:54 saboo rtkit-daemon[1543]: Successfully made thread 22178 of process 1866 (/usr/bin/pulseaudio) owned by '500' RT at priority 5.
> Sep 16 15:36:55 saboo rsyslogd-2177: imuxsock lost 52 messages from pid 22025 due to rate-limiting
> Sep 16 15:36:55 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:session_cb()
> Sep 16 15:36:55 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_parse_resp() START request succeeded
> Sep 16 15:36:55 saboo bluetoothd[22025]: bluetoothd[22025]: audio/a2dp.c:start_cfm() Source 0x7f1059476ad0: Start_Cfm
> Sep 16 15:36:55 saboo bluetoothd[22025]: bluetoothd[22025]: audio/unix.c:unix_ipc_sendmsg() Audio API: BT_RESPONSE -> BT_START_STREAM
> Sep 16 15:36:55 saboo bluetoothd[22025]: bluetoothd[22025]: audio/unix.c:unix_ipc_sendmsg() Audio API: BT_RESPONSE -> BT_NEW_STREAM
> Sep 16 15:36:55 saboo bluetoothd[22025]: bluetoothd[22025]: audio/a2dp.c:setup_unref() 0x7f105947e3f0: ref=0
> Sep 16 15:36:55 saboo bluetoothd[22025]: bluetoothd[22025]: audio/a2dp.c:setup_free() 0x7f105947e3f0
> Sep 16 15:36:55 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_unref() 0x7f105947b330: ref=3
> Sep 16 15:36:55 saboo bluetoothd[22025]: bluetoothd[22025]: audio/avdtp.c:avdtp_sep_set_state() stream state changed: OPEN -> STREAMING
> Sep 16 15:36:55 saboo bluetoothd[22025]: bluetoothd[22025]: audio/sink.c:sink_set_state() State changed /org/bluez/22025/hci0/dev_00_0B_E4_A6_6C_0D: SINK_STATE_CONNECTED -> SINK_STATE_PLAYING
>
> Thanks,
> 	J
>

