Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab1JTJMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 05:12:47 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57848 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab1JTJMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 05:12:45 -0400
MIME-Version: 1.0
In-Reply-To: <1319006699.31823.65.camel@wwguy-huron>
References: <20111019060108.GA11588@gamma.logic.tuwien.ac.at>
	<alpine.DEB.2.00.1110182305110.7719@chino.kir.corp.google.com>
	<CAOJsxLFXBQXDtjGkuHV8fpxSy4U0dOdzBm6=4xfy2dMQo7NvOg@mail.gmail.com>
	<1319003710.31823.53.camel@wwguy-huron>
	<20111019064818.GB14817@gamma.logic.tuwien.ac.at>
	<1319004938.31823.59.camel@wwguy-huron>
	<CAOJsxLHLmtYAR1c34Kkn+hzGeOSwhU646PP04pvTFx2e5M0NfA@mail.gmail.com>
	<1319006699.31823.65.camel@wwguy-huron>
Date: Thu, 20 Oct 2011 12:12:44 +0300
X-Google-Sender-Auth: cyjj-R0W3GSm4lIjeflHtaMNve8
Message-ID: <CAOJsxLGwQ=0uZsQvbeft7p4uf5oVXZ+V5nBf1-79w+w-5aUQkA@mail.gmail.com>
Subject: Re: iwlagn is getting very shaky
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Norbert Preining <preining@logic.at>, David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 9:44 AM, Guy, Wey-Yi <wey-yi.w.guy@intel.com> wrote:
>> As for the problems, I'm using iPhone 3G internet via WiFi sharing and
>> connection seems to die few times a day or if I take the phone far
>> enough from the laptop. I usually turn off the AP for a while and use
>> NetworkManager on the laptop to disable/enable networking to make it
>> come back up.
>>
>> I haven't tested anything but 3.1-rcX kernels on this machine but I
>> can do git bisect too if it comes to that.
>>
> I am just try to understand if you encounter the same problem as
> Norbert. if you can dump the tx_queue
> in /sys/kernel/debug/ieee80211/phX/iwlagn/debug folder and send me the
> log, thsat will be great.

Here's a dump of a very typical issue I'm seeing. I left the office
with my phone and once I came back, my laptop refused to reconnect to
the AP until I restarted wireless networking from NetworkManager. I've
sometimes seen the same symptoms even with laptop and the phone being
physically close to each other.

/sys/kernel/debug/ieee80211/phy0/iwlagn/debug/wd_timeout
cat: /sys/kernel/debug/ieee80211/phy0/iwlagn/debug/wd_timeout: Invalid argument
/sys/kernel/debug/ieee80211/phy0/iwlagn/debug/rxon_filter_flags
0x0004
/sys/kernel/debug/ieee80211/phy0/iwlagn/debug/rxon_flags
0x8005
/sys/kernel/debug/ieee80211/phy0/iwlagn/debug/reply_tx_error
Statistics_TX_Error:
DELAY:				0
FEW_BYTES:			0
BT_PRIO:			0
QUIET_PERIOD:			0
CALC_TTAK:			0
INTERNAL_CROSSED_RETRY:		0
SHORT_LIMIT:			0
LONG_LIMIT:			24
FIFO_UNDERRUN:			0
DRAIN_FLOW:			0
RFKILL_FLUSH:			0
LIFE_EXPIRE:			0
DEST_PS:			0
HOST_ABORTED:			0
BT_RETRY:			0
STA_INVALID:			0
FRAG_DROPPED:			0
TID_DISABLE:			0
FIFO_FLUSHED:			0
INSUFFICIENT_CF_POLL:		0
PASSIVE_NO_RX:			1
NO_BEACON_ON_RADAR:		0
UNKNOWN:			0

Statistics_Agg_TX_Error:
UNDERRUN_MSK:			0
BT_PRIO_MSK:			0
FEW_BYTES_MSK:			0
ABORT_MSK:			0
LAST_SENT_TTL_MSK:		0
LAST_SENT_TRY_CNT_MSK:		0
LAST_SENT_BT_KILL_MSK:		0
SCD_QUERY_MSK:			0
TEST_BAD_CRC32_MSK:		0
RESPONSE_MSK:			0
DUMP_TX_MSK:			0
DELAY_TX_MSK:			0
UNKNOWN:			0
/sys/kernel/debug/ieee80211/phy0/iwlagn/debug/ucode_bt_stats
Statistics Flag(0x30002):
	Operational Frequency: 2.4 GHz
	TGj Narrow Band: disabled
Statistics_BT:
			current			accumulative
hi_priority_tx_req_cnt:		0			0
hi_priority_tx_denied_cnt:	0			0
lo_priority_tx_req_cnt:		0			0
lo_priority_tx_denied_cnt:	0			0
hi_priority_rx_req_cnt:		0			0
hi_priority_rx_denied_cnt:	0			0
lo_priority_rx_req_cnt:		0			0
lo_priority_rx_denied_cnt:	0			0
(rx)num_bt_kills:		0			0
/sys/kernel/debug/ieee80211/phy0/iwlagn/debug/ucode_tracing
ucode trace timer is Off
non_wraps_count:		 0
wraps_once_count:		 0
wraps_more_count:		 0
/sys/kernel/debug/ieee80211/phy0/iwlagn/debug/chain_noise
active_chains:			 3
chain_noise_a:			 330
chain_noise_b:			 335
chain_noise_c:			 0
chain_signal_a:			 575
chain_signal_b:			 674
chain_signal_c:			 0
beacon_count:			 16
disconn_array:			 0 0 1
delta_gain_code:		 4 0 0
radio_write:			 1
state:				 3
/sys/kernel/debug/ieee80211/phy0/iwlagn/debug/sensitivity
auto_corr_ofdm:			 80
auto_corr_ofdm_mrc:		 128
auto_corr_ofdm_x1:		 105
auto_corr_ofdm_mrc_x1:		 192
auto_corr_cck:			 125
auto_corr_cck_mrc:		 160
last_bad_plcp_cnt_ofdm:		 0
last_fa_cnt_ofdm:		 0
last_bad_plcp_cnt_cck:		 0
last_fa_cnt_cck:		 0
nrg_curr_state:			 0
nrg_prev_state:			 0
nrg_value:			 0 0 0 0 0 0 0 0 0 0
nrg_silence_rssi:		 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
nrg_silence_ref:		 0
nrg_energy_idx:			 0
nrg_silence_idx:		 0
nrg_th_cck:			 97
nrg_auto_corr_silence_diff:	 0
num_in_cck_no_fa:		 0
nrg_th_ofdm:			 100
/sys/kernel/debug/ieee80211/phy0/iwlagn/debug/protection_mode
use rts/cts for aggregation
/sys/kernel/debug/ieee80211/phy0/iwlagn/debug/txfifo_flush
cat: /sys/kernel/debug/ieee80211/phy0/iwlagn/debug/txfifo_flush:
Invalid argument
/sys/kernel/debug/ieee80211/phy0/iwlagn/debug/ucode_general_stats
Statistics Flag(0x30002):
	Operational Frequency: 2.4 GHz
	TGj Narrow Band: disabled
Statistics_General:                 current  cumulative       delta         max
  temperature:                           32
  temperature_m:                       3437
  ttl_timestamp:                 1351982035
  burst_check:                            0         888          32          33
  burst_count:                            0           0           0           0
  wait_for_silence_timeout_count:          0         101           1           1
  sleep_time:                             0           0           0           0
  slots_out:                              0           0           0           0
  slots_idle:                             0           0           0           0
  tx_on_a:                                0           0           0           0
  tx_on_b:                                0           0           0           0
  exec_time:                              0           0           0           0
  probe_time:                             0         233           1           1
  rx_enable_counter:                      0           0           0           0
 /sys/kernel/debug/ieee80211/phy0/iwlagn/debug/ucode_tx_stats
Statistics Flag(0x30002):
	Operational Frequency: 2.4 GHz
	TGj Narrow Band: disabled
Statistics_Tx:                      current  cumulative       delta         max
  preamble:                               0       69043           5         156
  rx_detected_cnt:                        0        1175           1          34
  bt_prio_defer_cnt:                      0           0           0           0
  bt_prio_kill_cnt:                       0           0           0           0
  few_bytes_cnt:                          0           0           0           0
  cts_timeout:                            0           0           0           0
  ack_timeout:                            0        2410           2          45
  expected_ack_cnt:                       0       37195           5          81
  actual_ack_cnt:                         0       34785           3          73
  dump_msdu_cnt:                          0          64           2           3
  abort_nxt_frame_mismatch:               0           0           0           0
  abort_missing_nxt_frame:                0           0           0           0
  cts_timeout_collision:                  0           0           0           0
  ack_ba_timeout_collision:               0         146           1           4
  agg ba_timeout:                         0           0           0           0
  agg ba_resched_frames:                  0           0           0           0
  agg scd_query_agg_frame:                0           0           0           0
  agg scd_query_no_agg:                   0           0           0           0
  agg scd_query_agg:                      0           0           0           0
  agg scd_query_mismatch:                 0           0           0           0
  agg frame_not_ready:                    0           0           0           0
  agg underrun:                           0           0           0           0
  agg bt_prio_kill:                       0           0           0           0
  agg rx_ba_rsp_cnt:                      0           0           0           0
tx power: (1/2 dB step)
  antenna A:                           0x1C
  antenna B:                           0x1C
/sys/kernel/debug/ieee80211/phy0/iwlagn/debug/ucode_rx_stats
Statistics Flag(0x30002):
	Operational Frequency: 2.4 GHz
	TGj Narrow Band: disabled
Statistics_Rx - OFDM:               current  cumulative       delta         max
  ina_cnt:                                4     1739356           3        2107
  fina_cnt:                               2     1407532           2         773
  plcp_err:                               2     1241567           2         773
  crc32_err:                              0        7362           1          85
  overrun_err:                            0           0           0           0
  early_overrun_err:                      0           0           0           0
  crc32_good:                             0      172221           4         283
  false_alarm_cnt:                        2      354918           1        2139
  fina_sync_err_cnt:                      0        1490           1          30
  sfd_timeout:                            0           0           0           0
  fina_timeout:                           0           0           0           0
  unresponded_rts:                        0           0           0           0
  rxe_frame_lmt_ovrun:                    0         121           1          30
  sent_ack_cnt:                           0       30667           3          72
  sent_cts_cnt:                           0           0           0           0
  sent_ba_rsp_cnt:                        0           0           0           0
  dsp_self_kill:                          0           0           0           0
  mh_format_err:                          0           0           0           0
  re_acq_main_rssi_sum:                   0           0           0           0
Statistics_Rx - CCK:                current  cumulative       delta         max
  ina_cnt:                                1     1714491           1        1408
  fina_cnt:                               1     1713486           1        1407
  plcp_err:                               1      603100           1        1270
  crc32_err:                              0        3851           1          27
  overrun_err:                            0           0           0           0
  early_overrun_err:                      0           0           0           0
  crc32_good:                             0      650281           8         112
  false_alarm_cnt:                        0           0           0           0
  fina_sync_err_cnt:                      0        1060           1           3
  sfd_timeout:                            0           0           0           0
  fina_timeout:                           0           0           0           0
  unresponded_rts:                        0           0           0           0
  rxe_frame_lmt_ovrun:                    0           2           1           1
  sent_ack_cnt:                           0          52           1           5
  sent_cts_cnt:                           0           0           0           0
  sent_ba_rsp_cnt:                        0           0           0           0
  dsp_self_kill:                          0           0           0           0
  mh_format_err:                          0           0           0           0
  re_acq_main_rssi_sum:                   0           0           0           0
Statistics_Rx - GENERAL:            current  cumulative       delta         max
  bogus_cts:                              0           2           1           1
  bogus_ack:                              0           9           1           2
  non_bssid_frames:                       0           0           0           0
  filtered_frames:                        0      549185           1          83
  non_channel_beacons:                    0           0           0           0
  channel_beacons:                        0       87279           1           1
  num_missed_bcon:                        0         110           6          10
  adc_rx_saturation_time:                 0           0           0           0
  ina_detect_search_tm:                   0    77790045       65535       65535
  beacon_silence_rssi_a:                  0    32156769        3082       11822
  beacon_silence_rssi_b:                  0    63539976        6419       12593
  beacon_silence_rssi_c:                  0           0           0           0
  interference_data_flag:                 0        1236           1           1
  channel_load:                           0   988646230        2218     4167874
  dsp_false_alarms:                       0      163030          18         255
  beacon_rssi_a:                          0      127134           1          45
  beacon_rssi_b:                          0       91295           3          45
  beacon_rssi_c:                          0           0           0           0
  beacon_energy_a:                        0      215369           5          88
  beacon_energy_b:                        0      100030           2          91
  beacon_energy_c:                        0      113982           5          93
Statistics_Rx - OFDM_HT:            current  cumulative       delta         max
  plcp_err:                               0           0           0           0
  overrun_err:                            0           0           0           0
  early_overrun_err:                      0           0           0           0
  crc32_good:                             0           0           0           0
  crc32_err:                              0           0           0           0
  mh_format_err:                          0           0           0           0
  agg_crc32_good:                         0         115           2          30
  agg_mpdu_cnt:                           0         198          15          44
  agg_cnt:                                0          69           1          17
  unsupport_mcs:                          0         356           1          31
/sys/kernel/debug/ieee80211/phy0/iwlagn/debug/force_reset
Force reset method 0
	number of reset request: 102
	number of reset request success: 79
	number of reset request reject: 23
	reset duration: 3000
Force reset method 1
	number of reset request: 0
	number of reset request success: 0
	number of reset request reject: 0
	reset duration: 5000
/sys/kernel/debug/ieee80211/phy0/iwlagn/debug/plcp_delta
50
/sys/kernel/debug/ieee80211/phy0/iwlagn/debug/missed_beacon
5
/sys/kernel/debug/ieee80211/phy0/iwlagn/debug/fh_reg
FH register values:
        FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X0fff1e00
       FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X00fff1f0
                 FH_RSCSR_CHNL0_WPTR: 0X000000d8
        FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
         FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
           FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
   FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
               FH_TSSR_TX_STATUS_REG: 0X07ff0001
                FH_TSSR_TX_ERROR_REG: 0X00000000
/sys/kernel/debug/ieee80211/phy0/iwlagn/debug/csr
cat: /sys/kernel/debug/ieee80211/phy0/iwlagn/debug/csr: Invalid argument
/sys/kernel/debug/ieee80211/phy0/iwlagn/debug/clear_traffic_statistics
cat: /sys/kernel/debug/ieee80211/phy0/iwlagn/debug/clear_traffic_statistics:
Invalid argument
/sys/kernel/debug/ieee80211/phy0/iwlagn/debug/clear_ucode_statistics
cat: /sys/kernel/debug/ieee80211/phy0/iwlagn/debug/clear_ucode_statistics:
Invalid argument
/sys/kernel/debug/ieee80211/phy0/iwlagn/debug/power_save_status
Power Save Status: PHY
/sys/kernel/debug/ieee80211/phy0/iwlagn/debug/tx_queue
hwq 00: read=37 write=37 stop=0 swq_id=0x00 (ac 0/hwq 0)
        stop-count: 0
hwq 01: read=0 write=0 stop=0 swq_id=0x05 (ac 1/hwq 1)
        stop-count: 0
hwq 02: read=194 write=194 stop=0 swq_id=0x0a (ac 2/hwq 2)
        stop-count: 0
hwq 03: read=0 write=0 stop=0 swq_id=0x0f (ac 3/hwq 3)
        stop-count: 0
hwq 04: read=0 write=0 stop=0 swq_id=0x13 (ac 3/hwq 4)
hwq 05: read=0 write=0 stop=0 swq_id=0x16 (ac 2/hwq 5)
hwq 06: read=0 write=0 stop=0 swq_id=0x19 (ac 1/hwq 6)
hwq 07: read=0 write=0 stop=0 swq_id=0x1c (ac 0/hwq 7)
hwq 08: read=0 write=0 stop=0 swq_id=0x22 (ac 2/hwq 8)
hwq 09: read=75 write=75 stop=0 swq_id=0x00 (ac 0/hwq 0)
hwq 10: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
hwq 11: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
hwq 12: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
hwq 13: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
hwq 14: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
hwq 15: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
hwq 16: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
hwq 17: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
hwq 18: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
hwq 19: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
/sys/kernel/debug/ieee80211/phy0/iwlagn/debug/rx_queue
read: 223
write: 221
free_count: 32
closed_rb_num: 223
/sys/kernel/debug/ieee80211/phy0/iwlagn/debug/traffic_log
Tx Queue
q[0]: read_ptr: 37, write_ptr: 37
q[1]: read_ptr: 0, write_ptr: 0
q[2]: read_ptr: 194, write_ptr: 194
q[3]: read_ptr: 0, write_ptr: 0
q[4]: read_ptr: 0, write_ptr: 0
q[5]: read_ptr: 0, write_ptr: 0
q[6]: read_ptr: 0, write_ptr: 0
q[7]: read_ptr: 0, write_ptr: 0
q[8]: read_ptr: 0, write_ptr: 0
q[9]: read_ptr: 75, write_ptr: 75
q[10]: read_ptr: 0, write_ptr: 0
q[11]: read_ptr: 0, write_ptr: 0
q[12]: read_ptr: 0, write_ptr: 0
q[13]: read_ptr: 0, write_ptr: 0
q[14]: read_ptr: 0, write_ptr: 0
q[15]: read_ptr: 0, write_ptr: 0
q[16]: read_ptr: 0, write_ptr: 0
q[17]: read_ptr: 0, write_ptr: 0
q[18]: read_ptr: 0, write_ptr: 0
q[19]: read_ptr: 0, write_ptr: 0
Rx Queue
read: 223, write: 221
/sys/kernel/debug/ieee80211/phy0/iwlagn/debug/tx_statistics
Management:
	     MANAGEMENT_ASSOC_REQ		: 1
	    MANAGEMENT_ASSOC_RESP		: 0
	   MANAGEMENT_REASSOC_REQ		: 3
	  MANAGEMENT_REASSOC_RESP		: 0
	     MANAGEMENT_PROBE_REQ		: 0
	    MANAGEMENT_PROBE_RESP		: 0
	        MANAGEMENT_BEACON		: 0
	          MANAGEMENT_ATIM		: 0
	      MANAGEMENT_DISASSOC		: 0
	          MANAGEMENT_AUTH		: 19
	        MANAGEMENT_DEAUTH		: 4
	        MANAGEMENT_ACTION		: 0
Control
	         CONTROL_BACK_REQ		: 0
	             CONTROL_BACK		: 0
	           CONTROL_PSPOLL		: 0
	              CONTROL_RTS		: 0
	              CONTROL_CTS		: 0
	              CONTROL_ACK		: 0
	            CONTROL_CFEND		: 0
	         CONTROL_CFENDACK		: 0
Data:
	cnt: 32204
	bytes: 5475621
/sys/kernel/debug/ieee80211/phy0/iwlagn/debug/rx_statistics
Management:
	     MANAGEMENT_ASSOC_REQ		: 0
	    MANAGEMENT_ASSOC_RESP		: 1
	   MANAGEMENT_REASSOC_REQ		: 0
	  MANAGEMENT_REASSOC_RESP		: 3
	     MANAGEMENT_PROBE_REQ		: 0
	    MANAGEMENT_PROBE_RESP		: 149
	        MANAGEMENT_BEACON		: 106894
	          MANAGEMENT_ATIM		: 0
	      MANAGEMENT_DISASSOC		: 0
	          MANAGEMENT_AUTH		: 4
	        MANAGEMENT_DEAUTH		: 0
	        MANAGEMENT_ACTION		: 0
Control:
	         CONTROL_BACK_REQ		: 0
	             CONTROL_BACK		: 0
	           CONTROL_PSPOLL		: 0
	              CONTROL_RTS		: 0
	              CONTROL_CTS		: 0
	              CONTROL_ACK		: 0
	            CONTROL_CFEND		: 0
	         CONTROL_CFENDACK		: 0
Data:
	cnt: 30900
	bytes: 18938054
