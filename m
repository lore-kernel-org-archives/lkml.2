Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab0JTPlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 11:41:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51826 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744Ab0JTPlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 11:41:22 -0400
Date: Wed, 20 Oct 2010 17:40:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH][GIT PULL] tracing: Fix compile issue for
 trace_sched_wakeup.c
Message-ID: <20101020154045.GA18353@elte.hu>
References: <1287508282.16971.386.camel@gandalf.stny.rr.com>
 <20101019184111.GA17266@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <20101019184111.GA17266@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -0.2
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.2 required=5.9 tests=BAYES_00,FRT_LEVITRA autolearn=no SpamAssassin version=3.2.5
	1.8 FRT_LEVITRA            BODY: ReplaceTags: Levitra
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


FYI, there's a new mystery hang (sometimes crash) that triggers in -tip - and which 
seems to be tracing related. See the crashlog below - config attached.

It's not bisectable - small changes in the kernel make the bug come/go. (might be a 
race of some sorts)

Thanks,

	Ingo


[ .... ]
[   33.996015] bus: 'pci': add driver S3 SonicVibes
[   34.000059] initcall alsa_card_sonicvibes_init+0x0/0x16 returned 0 after 3906 usecs
[   34.004009] calling  alsa_card_via82xx_init+0x0/0x16 @ 1
[   34.008015] bus: 'pci': add driver VIA 82xx Modem
[   34.012059] initcall alsa_card_via82xx_init+0x0/0x16 returned 0 after 3906 usecs
[   34.016009] calling  alsa_ac97_init+0x0/0x7 @ 1
[   34.020005] initcall alsa_ac97_init+0x0/0x7 returned 0 after 0 usecs
[   34.024006] calling  snd_asihpi_init+0x0/0x1b @ 1
[   34.028008] ASIHPI driver 4.04.01
[   34.032053] bus: 'pci': add driver asihpi
[   34.036060] initcall snd_asihpi_init+0x0/0x1b returned 0 after 7812 usecs
[   34.040009] calling  alsa_card_vortex_init+0x0/0x16 @ 1
[   34.044015] bus: 'pci': add driver au8810
[   34.048058] initcall alsa_card_vortex_init+0x0/0x16 returned 0 after 3906 usecs
[   34.052009] calling  alsa_card_vortex_init+0x0/0x16 @ 1
[   34.056016] bus: 'pci': add driver au8820
[   34.060064] initcall alsa_card_vortex_init+0x0/0x16 returned 0 after 3906 usecs
[   34.064009] calling  alsa_card_vortex_init+0x0/0x16 @ 1
[   34.068016] bus: 'pci': add driver au8830
[   34.072061] initcall alsa_card_vortex_init+0x0/0x16 returned 0 after 3906 usecs
[   34.076009] calling  alsa_card_ca0106_init+0x0/0x16 @ 1
[   34.080015] bus: 'pci': add driver CA0106
[   34.084060] initcall alsa_card_ca0106_init+0x0/0x16 returned 0 after 3906 usecs
[   34.088009] calling  alsa_card_cs46xx_init+0x0/0x16 @ 1
[   34.092016] bus: 'pci': add driver Sound Fusion CS46xx
[   34.100044] initcall alsa_card_cs46xx_init+0x0/0x16 returned 0 after 7812 usecs
[   34.104005] calling  alsa_card_cs5535audio_init+0x0/0x16 @ 1
[   34.108016] bus: 'pci': add driver cs5535audio
[   34.112070] initcall alsa_card_cs5535audio_init+0x0/0x16 returned 0 after 3906 usecs
[   34.116006] calling  alsa_card_echo_init+0x0/0x16 @ 1
[   34.120017] bus: 'pci': add driver Echoaudio Gina20
[   34.124068] initcall alsa_card_echo_init+0x0/0x16 returned 0 after 3906 usecs
[   34.128006] calling  alsa_card_echo_init+0x0/0x16 @ 1
[   34.132016] bus: 'pci': add driver Echoaudio Layla20
[   34.136066] initcall alsa_card_echo_init+0x0/0x16 returned 0 after 3906 usecs
[   34.140006] calling  alsa_card_echo_init+0x0/0x16 @ 1
[   34.144016] bus: 'pci': add driver Echoaudio Darla24
[   34.148067] initcall alsa_card_echo_init+0x0/0x16 returned 0 after 3906 usecs
[   34.152009] calling  alsa_card_echo_init+0x0/0x16 @ 1
[   34.156016] bus: 'pci': add driver Echoaudio Mona
[   34.160067] initcall alsa_card_echo_init+0x0/0x16 returned 0 after 3906 usecs
[   34.164006] calling  alsa_card_echo_init+0x0/0x16 @ 1
[   34.168016] bus: 'pci': add driver Echoaudio Mia
[   34.172066] initcall alsa_card_echo_init+0x0/0x16 returned 0 after 3906 usecs
[   34.176006] calling  alsa_card_echo_init+0x0/0x16 @ 1
[   34.180017] bus: 'pci': add driver Echoaudio Indigo
[   34.184067] initcall alsa_card_echo_init+0x0/0x16 returned 0 after 3906 usecs
[   34.188006] calling  alsa_card_echo_init+0x0/0x16 @ 1
[   34.192020] bus: 'pci': add driver Echoaudio Indigo IOx
[   34.196067] initcall alsa_card_echo_init+0x0/0x16 returned 0 after 3906 usecs
[   34.200006] calling  alsa_card_echo_init+0x0/0x16 @ 1
[   34.204017] bus: 'pci': add driver Echoaudio Indigo DJx
[   34.208067] initcall alsa_card_echo_init+0x0/0x16 returned 0 after 3906 usecs
[   34.212006] calling  alsa_card_emu10k1_init+0x0/0x16 @ 1
[   34.216016] bus: 'pci': add driver EMU10K1_Audigy
[   34.220066] initcall alsa_card_emu10k1_init+0x0/0x16 returned 0 after 3906 usecs
[   34.224006] calling  alsa_card_emu10k1x_init+0x0/0x16 @ 1
[   34.228016] bus: 'pci': add driver EMU10K1X
[   34.232075] initcall alsa_card_emu10k1x_init+0x0/0x16 returned 0 after 3906 usecs
[   34.236006] calling  alsa_card_ice1724_init+0x0/0x16 @ 1
[   34.240017] bus: 'pci': add driver ICE1724
[   34.244067] initcall alsa_card_ice1724_init+0x0/0x16 returned 0 after 3906 usecs
[   34.248006] calling  alsa_ice1712_akm4xxx_module_init+0x0/0x7 @ 1
[   34.252006] initcall alsa_ice1712_akm4xxx_module_init+0x0/0x7 returned 0 after 0 usecs
[   34.256009] calling  alsa_card_mixart_init+0x0/0x16 @ 1
[   34.260017] bus: 'pci': add driver Digigram miXart
[   34.264063] initcall alsa_card_mixart_init+0x0/0x16 returned 0 after 3906 usecs
[   34.268009] calling  alsa_card_oxygen_init+0x0/0x16 @ 1
[   34.272020] bus: 'pci': add driver CMI8788
[   34.276063] initcall alsa_card_oxygen_init+0x0/0x16 returned 0 after 3906 usecs
[   34.280009] calling  alsa_card_xonar_init+0x0/0x16 @ 1
[   34.284016] bus: 'pci': add driver AV200
[   34.288063] initcall alsa_card_xonar_init+0x0/0x16 returned 0 after 3906 usecs
[   34.292009] calling  pcxhr_module_init+0x0/0x16 @ 1
[   34.296017] bus: 'pci': add driver Digigram pcxhr
[   34.300065] initcall pcxhr_module_init+0x0/0x16 returned 0 after 3906 usecs
[   34.304009] calling  alsa_card_hammerfall_init+0x0/0x16 @ 1
[   34.308017] bus: 'pci': add driver RME Digi9652 (Hammerfall)
[   34.312067] initcall alsa_card_hammerfall_init+0x0/0x16 returned 0 after 3906 usecs
[   34.316009] calling  alsa_card_trident_init+0x0/0x16 @ 1
[   34.320017] bus: 'pci': add driver Trident4DWaveAudio
[   34.324063] initcall alsa_card_trident_init+0x0/0x16 returned 0 after 3906 usecs
[   34.328009] calling  alsa_card_ymfpci_init+0x0/0x16 @ 1
[   34.332017] bus: 'pci': add driver Yamaha DS-1 PCI
[   34.336063] initcall alsa_card_ymfpci_init+0x0/0x16 returned 0 after 3906 usecs
[   34.340010] calling  alsa_util_mem_init+0x0/0x7 @ 1
[   34.344006] initcall alsa_util_mem_init+0x0/0x7 returned 0 after 0 usecs
[   34.348005] calling  init_vxpocket+0x0/0xf @ 1
[   34.352015] bus: 'pcmcia': add driver snd-vxpocket
[   34.356036] initcall init_vxpocket+0x0/0xf returned 0 after 3906 usecs
[   34.360006] calling  snd_soc_init+0x0/0x40 @ 1
[   34.364040] bus: 'platform': add driver soc-audio
[   34.368042] initcall snd_soc_init+0x0/0x40 returned 0 after 3906 usecs
[   34.372006] calling  alsa_sound_last_init+0x0/0x50 @ 1
[   34.376008] ALSA device list:
[   34.380004]   #0: NVidia CK804 with ALC850 at irq 27
[   34.384006] initcall alsa_sound_last_init+0x0/0x50 returned 0 after 7812 usecs
[   34.388010] calling  flow_cache_init_global+0x0/0x141 @ 1
[   34.392197] initcall flow_cache_init_global+0x0/0x141 returned 0 after 0 usecs
[   34.396006] calling  pg_init+0x0/0x2d4 @ 1
[   34.400009] pktgen: Packet Generator for packet performance testing. Version: 2.74
[   34.408087] initcall pg_init+0x0/0x2d4 returned 0 after 7812 usecs
[   34.412010] calling  llc_init+0x0/0x1b @ 1
[   34.416009] initcall llc_init+0x0/0x1b returned 0 after 0 usecs
[   34.420005] calling  llc2_init+0x0/0xb5 @ 1
[   34.424039] NET: Registered protocol family 26
[   34.428006] initcall llc2_init+0x0/0xb5 returned 0 after 3906 usecs
[   34.432009] calling  snap_init+0x0/0x31 @ 1
[   34.436034] initcall snap_init+0x0/0x31 returned 0 after 0 usecs
[   34.440006] calling  rif_init+0x0/0x71 @ 1
[   34.444016] initcall rif_init+0x0/0x71 returned 0 after 0 usecs
[   34.448009] calling  sysctl_ipv4_init+0x0/0x71 @ 1
[   34.452019] initcall sysctl_ipv4_init+0x0/0x71 returned 0 after 0 usecs
[   34.456006] calling  ipip_init+0x0/0x50 @ 1
[   34.460007] IPv4 over IPv4 tunneling driver
[   34.464028] device: 'tunl0': device_add
[   34.468118] PM: Adding info for No Bus:tunl0
[   34.472127] initcall ipip_init+0x0/0x50 returned 0 after 11718 usecs
[   34.476006] calling  init_syncookies+0x0/0x16 @ 1
[   34.480057] initcall init_syncookies+0x0/0x16 returned 0 after 0 usecs
[   34.484009] calling  ah4_init+0x0/0x5a @ 1
[   34.488009] initcall ah4_init+0x0/0x5a returned 0 after 0 usecs
[   34.492005] calling  esp4_init+0x0/0x5a @ 1
[   34.496011] initcall esp4_init+0x0/0x5a returned 0 after 0 usecs
[   34.500005] calling  ipcomp4_init+0x0/0x5a @ 1
[   34.504027] initcall ipcomp4_init+0x0/0x5a returned 0 after 0 usecs
[   34.508009] calling  ipip_init+0x0/0x88 @ 1
[   34.512013] initcall ipip_init+0x0/0x88 returned 0 after 0 usecs
[   34.516006] calling  xfrm4_beet_init+0x0/0x14 @ 1
[   34.520010] initcall xfrm4_beet_init+0x0/0x14 returned 0 after 0 usecs
[   34.524006] calling  tunnel4_init+0x0/0x5a @ 1
[   34.528007] initcall tunnel4_init+0x0/0x5a returned 0 after 0 usecs
[   34.532009] calling  xfrm4_mode_tunnel_init+0x0/0x14 @ 1
[   34.536007] initcall xfrm4_mode_tunnel_init+0x0/0x14 returned 0 after 0 usecs
[   34.540006] calling  inet_diag_init+0x0/0xbd @ 1
[   34.544033] initcall inet_diag_init+0x0/0xbd returned 0 after 0 usecs
[   34.548006] calling  tcp_diag_init+0x0/0xf @ 1
[   34.552033] initcall tcp_diag_init+0x0/0xf returned 0 after 0 usecs
[   34.556009] calling  cubictcp_register+0x0/0x77 @ 1
[   34.560005] TCP cubic registered
[   34.564006] initcall cubictcp_register+0x0/0x77 returned 0 after 3906 usecs
[   34.568009] calling  inet6_init+0x0/0x27f @ 1
[   34.572568] NET: Registered protocol family 10
[   34.576437] lo: Disabled Privacy Extensions
[   34.584305] tunl0: Disabled Privacy Extensions
[   34.588132] initcall inet6_init+0x0/0x27f returned 0 after 15625 usecs
[   34.592013] calling  esp6_init+0x0/0x5a @ 1
[   34.596009] initcall esp6_init+0x0/0x5a returned 0 after 0 usecs
[   34.600005] calling  xfrm6_transport_init+0x0/0x14 @ 1
[   34.604029] initcall xfrm6_transport_init+0x0/0x14 returned 0 after 0 usecs
[   34.608005] calling  mip6_init+0x0/0xa7 @ 1
[   34.612004] Mobile IPv6
[   34.616010] initcall mip6_init+0x0/0xa7 returned 0 after 3906 usecs
[   34.620005] calling  sit_init+0x0/0x50 @ 1
[   34.624004] IPv6 over IPv4 tunneling driver
[   34.628025] device: 'sit0': device_add
[   34.632120] PM: Adding info for No Bus:sit0
[   34.636100] sit0: Disabled Privacy Extensions
[   34.640079] initcall sit_init+0x0/0x50 returned 0 after 15625 usecs
[   34.644006] calling  packet_init+0x0/0x39 @ 1
[   34.648006] NET: Registered protocol family 17
[   34.652021] initcall packet_init+0x0/0x39 returned 0 after 3906 usecs
[   34.656005] calling  ipsec_pfkey_init+0x0/0x6b @ 1
[   34.660013] NET: Registered protocol family 15
[   34.664029] initcall ipsec_pfkey_init+0x0/0x6b returned 0 after 3906 usecs
[   34.668005] calling  ipx_init+0x0/0xd2 @ 1
[   34.672028] NET: Registered protocol family 4
[   34.688037] initcall ipx_init+0x0/0xd2 returned 0 after 15625 usecs
[   34.692005] calling  atalk_init+0x0/0x77 @ 1
[   34.696006] NET: Registered protocol family 5
[   34.720038] initcall atalk_init+0x0/0x77 returned 0 after 23437 usecs
[   34.724009] calling  can_init+0x0/0xc6 @ 1
[   34.728004] can: controller area network core (rev 20090105 abi 8)
[   34.732069] NET: Registered protocol family 29
[   34.736013] initcall can_init+0x0/0xc6 returned 0 after 7812 usecs
[   34.740005] calling  raw_module_init+0x0/0x31 @ 1
[   34.744004] can: raw protocol (rev 20090105)
[   34.748036] initcall raw_module_init+0x0/0x31 returned 0 after 3906 usecs
[   34.752009] calling  bcm_module_init+0x0/0x4a @ 1
[   34.756004] can: broadcast manager protocol (rev 20090105 t)
[   34.760015] initcall bcm_module_init+0x0/0x4a returned 0 after 3906 usecs
[   34.764005] calling  af_rxrpc_init+0x0/0x170 @ 1
[   34.768081] NET: Registered protocol family 33
[   34.772054] initcall af_rxrpc_init+0x0/0x170 returned 0 after 3906 usecs
[   34.780006] calling  rxkad_init+0x0/0x2f @ 1
[   34.784894] RxRPC: Registered security type 2 'rxkad'
[   34.788009] initcall rxkad_init+0x0/0x2f returned 0 after 3906 usecs
[   34.792028] cryptomgr_probe used greatest stack depth: 6940 bytes left
[   34.796032] calling  l2tp_init+0x0/0x2c @ 1
[   34.800011] L2TP core driver, V2.0
[   34.804023] initcall l2tp_init+0x0/0x2c returned 0 after 3906 usecs
[   34.808019] calling  pppol2tp_init+0x0/0x88 @ 1
[   34.812017] PPPoL2TP kernel driver, V2.0
[   34.816029] initcall pppol2tp_init+0x0/0x88 returned 0 after 3906 usecs
[   34.820013] calling  l2tp_nl_init+0x0/0x28 @ 1
[   34.824005] L2TP netlink interface
[   34.827416] initcall l2tp_nl_init+0x0/0x28 returned 0 after 0 usecs
[   34.828006] calling  decnet_init+0x0/0x77 @ 1
[   34.832011] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
[   34.836257] DECnet: Routing cache hash table of 1024 buckets, 44Kbytes
[   34.840055] NET: Registered protocol family 12
[   34.844025] initcall decnet_init+0x0/0x77 returned 0 after 11718 usecs
[   34.848006] calling  econet_proto_init+0x0/0x2f @ 1
[   34.852007] NET: Registered protocol family 19
[   34.856011] initcall econet_proto_init+0x0/0x2f returned 0 after 3906 usecs
[   34.860006] calling  phonet_init+0x0/0x70 @ 1
[   34.864017] NET: Registered protocol family 35
[   34.868062] initcall phonet_init+0x0/0x70 returned 0 after 3906 usecs
[   34.872009] calling  pep_register+0x0/0x14 @ 1
[   34.876149] initcall pep_register+0x0/0x14 returned 0 after 0 usecs
[   34.880010] calling  vlan_proto_init+0x0/0x9d @ 1
[   34.884005] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[   34.888004] All bugs added by David S. Miller <davem@redhat.com>
[   34.892072] initcall vlan_proto_init+0x0/0x9d returned 0 after 7812 usecs
[   34.896006] calling  dccp_init+0x0/0x319 @ 1
[   34.906804] CCID: Activated CCID 2 (TCP-like)
[   34.908014] initcall dccp_init+0x0/0x319 returned 0 after 7812 usecs
[   34.912011] calling  dccp_v4_init+0x0/0x72 @ 1
[   34.916343] initcall dccp_v4_init+0x0/0x72 returned 0 after 0 usecs
[   34.920006] calling  dccp_v6_init+0x0/0x72 @ 1
[   34.924301] initcall dccp_v6_init+0x0/0x72 returned 0 after 0 usecs
[   34.928010] calling  dccp_diag_init+0x0/0xf @ 1
[   34.932007] initcall dccp_diag_init+0x0/0xf returned 0 after 0 usecs
[   34.936006] calling  sctp_init+0x0/0x7b9 @ 1
[   34.944859] SCTP: Hash tables configured (established 21845 bind 23831)
[   34.948388] sctp_init_sock(sk: f54bc000)
[   34.952052] initcall sctp_init+0x0/0x7b9 returned 0 after 11718 usecs
[   34.956005] calling  rds_init+0x0/0xa6 @ 1
[   34.960270] NET: Registered protocol family 21
[   34.964008] initcall rds_init+0x0/0xa6 returned 0 after 3906 usecs
[   34.972006] calling  rds_rdma_init+0x0/0xf2 @ 1
[   34.976158] Registered RDS/iwarp transport
[   34.980043] Registered RDS/infiniband transport
[   34.984007] initcall rds_rdma_init+0x0/0xf2 returned 0 after 7812 usecs
[   34.992005] calling  rds_tcp_init+0x0/0x80 @ 1
[   34.996031] Registered RDS/tcp transport
[   35.000198] initcall rds_tcp_init+0x0/0x80 returned 0 after 3906 usecs
[   35.008024] calling  tipc_init+0x0/0xab @ 1
[   35.012026] TIPC: Activated (version 2.0.0 compiled Oct 20 2010 08:00:42)
[   35.016550] NET: Registered protocol family 30
[   35.024010] TIPC: Started in single node mode
[   35.028009] initcall tipc_init+0x0/0xab returned 0 after 15625 usecs
[   35.032006] calling  caif_device_init+0x0/0x6b @ 1
[   35.036054] initcall caif_device_init+0x0/0x6b returned 0 after 3906 usecs
[   35.044006] calling  caif_sktinit_module+0x0/0x132 @ 1
[   35.052129] NET: Registered protocol family 37
[   35.056006] initcall caif_sktinit_module+0x0/0x132 returned 0 after 3906 usecs
[   35.060005] calling  dcbnl_init+0x0/0x2d @ 1
[   35.068006] initcall dcbnl_init+0x0/0x2d returned 0 after 0 usecs
[   35.072005] calling  af_ieee802154_init+0x0/0x63 @ 1
[   35.076037] NET: Registered protocol family 36
[   35.080007] initcall af_ieee802154_init+0x0/0x63 returned 0 after 3906 usecs
[   35.088005] calling  init_dns_resolver+0x0/0xfb @ 1
[   35.092004] Registering the dns_resolver key type
[   35.100123] initcall init_dns_resolver+0x0/0xfb returned 0 after 7812 usecs
[   35.104007] calling  update_mp_table+0x0/0x567 @ 1
[   35.112027] initcall update_mp_table+0x0/0x567 returned 0 after 0 usecs
[   35.116006] calling  lapic_insert_resource+0x0/0x35 @ 1
[   35.124007] initcall lapic_insert_resource+0x0/0x35 returned 0 after 0 usecs
[   35.128005] calling  print_ipi_mode+0x0/0x26 @ 1
[   35.132004] Using IPI No-Shortcut mode
[   35.136006] initcall print_ipi_mode+0x0/0x26 returned 0 after 3906 usecs
[   35.144006] calling  init_lapic_nmi_sysfs+0x0/0x33 @ 1
[   35.148006] initcall init_lapic_nmi_sysfs+0x0/0x33 returned 0 after 0 usecs
[   35.156006] calling  io_apic_bug_finalize+0x0/0x1a @ 1
[   35.160006] initcall io_apic_bug_finalize+0x0/0x1a returned 0 after 0 usecs
[   35.168006] calling  check_early_ioremap_leak+0x0/0x5c @ 1
[   35.172006] initcall check_early_ioremap_leak+0x0/0x5c returned 0 after 0 usecs
[   35.180006] calling  pat_memtype_list_init+0x0/0x2e @ 1
[   35.188017] initcall pat_memtype_list_init+0x0/0x2e returned 0 after 0 usecs
[   35.192006] calling  init_oops_id+0x0/0x3f @ 1
[   35.196012] initcall init_oops_id+0x0/0x3f returned 0 after 0 usecs
[   35.204006] calling  printk_late_init+0x0/0x44 @ 1
[   35.208008] initcall printk_late_init+0x0/0x44 returned 0 after 0 usecs
[   35.216022] calling  pm_qos_power_init+0x0/0xae @ 1
[   35.220012] device: 'cpu_dma_latency': device_add
[   35.224282] PM: Adding info for No Bus:cpu_dma_latency
[   35.232031] device: 'network_latency': device_add
[   35.236114] PM: Adding info for No Bus:network_latency
[   35.240024] device: 'network_throughput': device_add
[   35.244114] PM: Adding info for No Bus:network_throughput
[   35.252022] initcall pm_qos_power_init+0x0/0xae returned 0 after 31250 usecs
[   35.260006] calling  taskstats_init+0x0/0x7d @ 1
[   35.264012] registered taskstats version 1
[   35.268006] initcall taskstats_init+0x0/0x7d returned 0 after 3906 usecs
[   35.272006] calling  clear_boot_tracer+0x0/0x27 @ 1
[   35.280008] initcall clear_boot_tracer+0x0/0x27 returned 0 after 0 usecs
[   35.284005] calling  event_trace_self_tests_init+0x0/0x39 @ 1
[   35.292004] Running tests on trace events:
[   35.296004] Testing event kfree_skb: OK
[   35.316691] Testing event consume_skb: OK
[   35.336608] Testing event skb_copy_datagram_iovec: OK
[   35.356583] Testing event net_dev_xmit: OK
[   35.376602] Testing event net_dev_queue: OK
[   35.396587] Testing event netif_receive_skb: OK
[   35.416597] Testing event netif_rx: OK
[   35.436580] Testing event napi_poll: OK
[   35.456599] Testing event scsi_dispatch_cmd_start: OK
[   35.476585] Testing event scsi_dispatch_cmd_error: OK
[   35.496587] Testing event scsi_dispatch_cmd_done: OK
[   35.516596] Testing event scsi_dispatch_cmd_timeout: OK
[   35.536580] Testing event scsi_eh_wakeup: OK
[   35.556583] Testing event drm_vblank_event: OK
[   35.576584] Testing event drm_vblank_event_queued: OK
[   35.596585] Testing event drm_vblank_event_delivered: OK
[   35.616614] Testing event lock_kernel: OK
[   35.636580] Testing event unlock_kernel: OK
[   35.656582] Testing event block_rq_abort: OK
[   35.676583] Testing event block_rq_requeue: OK
[   35.696585] Testing event block_rq_complete: OK
[   35.716595] Testing event block_rq_insert: OK
[   35.736580] Testing event block_rq_issue: OK
[   35.756581] Testing event block_bio_bounce: OK
[   35.776583] Testing event block_bio_complete: OK
[   35.796568] Testing event block_bio_backmerge: OK
[   35.816595] Testing event block_bio_frontmerge: OK
[   35.836580] Testing event block_bio_queue: OK
[   35.856581] Testing event block_getrq: OK
[   35.876583] Testing event block_sleeprq: OK
[   35.896584] Testing event block_plug: OK
[   35.916596] Testing event block_unplug_timer: OK
[   35.936580] Testing event block_unplug_io: OK
[   35.956607] Testing event block_split: OK
[   35.976582] Testing event block_remap: OK
[   35.996602] Testing event block_rq_remap: OK
[   36.016577] Testing event writeback_nothread: OK
[   36.036578] Testing event writeback_queue: OK
[   36.056580] Testing event writeback_exec: OK
[   36.076583] Testing event writeback_pages_written: OK
[   36.096583] Testing event writeback_nowork: OK
[   36.116595] Testing event writeback_wake_thread: OK
[   36.136578] Testing event writeback_wake_forker_thread: OK
[   36.156582] Testing event writeback_bdi_register: OK
[   36.176582] Testing event writeback_bdi_unregister: OK
[   36.196584] Testing event writeback_thread_start: OK
[   36.216595] Testing event writeback_thread_stop: OK
[   36.236587] Testing event wbc_writeback_start: OK
[   36.256580] Testing event wbc_writeback_written: OK
[   36.276581] Testing event wbc_writeback_wait: OK
[   36.296585] Testing event wbc_balance_dirty_start: OK
[   36.316593] Testing event wbc_balance_dirty_written: OK
[   36.336588] Testing event wbc_balance_dirty_wait: OK
[   36.356579] Testing event wbc_writepage: OK
[   36.376581] Testing event kmalloc: OK
[   36.477101] Testing event kmem_cache_alloc: OK
[   36.496583] Testing event kmalloc_node: OK
[   36.516620] Testing event kmem_cache_alloc_node: OK
[   36.536559] Testing event kfree: OK
[   36.552584] Testing event kmem_cache_free: OK
[   36.572586] Testing event mm_page_free_direct: OK
[   36.592588] Testing event mm_pagevec_free: OK
[   36.612580] Testing event mm_page_alloc: OK
[   36.632583] Testing event mm_page_alloc_zone_locked: OK
[   36.652583] Testing event mm_page_pcpu_drain: OK
[   36.672586] Testing event mm_page_alloc_extfrag: OK
[   36.692578] Testing event mm_vmscan_kswapd_sleep: OK
[   36.712580] Testing event mm_vmscan_kswapd_wake: OK
[   36.732582] Testing event mm_vmscan_wakeup_kswapd: OK
[   36.752583] Testing event mm_vmscan_direct_reclaim_begin: OK
[   36.772585] Testing event mm_vmscan_memcg_reclaim_begin: OK
[   36.792562] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[   36.812562] Testing event mm_vmscan_direct_reclaim_end: OK
[   36.832582] Testing event mm_vmscan_memcg_reclaim_end: OK
[   36.852567] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[   36.872568] Testing event mm_vmscan_lru_isolate: OK
[   36.892587] Testing event mm_vmscan_memcg_isolate: OK
[   36.912563] Testing event mm_vmscan_writepage: OK
[   36.932580] Testing event power_start: OK
[   36.952643] Testing event power_frequency: OK
[   36.972585] Testing event power_end: OK
[   36.992604] Testing event clock_enable: OK
[   37.012563] Testing event clock_disable: OK
[   37.032563] Testing event clock_set_rate: OK
[   37.052566] Testing event power_domain_target: OK
[   37.072569] Testing event lock_acquire: OK
[   37.092639] Testing event lock_release: OK
[   37.112639] Testing event lock_contended: OK
[   37.132581] Testing event lock_acquired: OK
[   37.152633] Testing event workqueue_execute_start: OK
[   37.172602] Testing event workqueue_execute_end: OK
[   37.192603] Testing event signal_generate: OK
[   37.212578] Testing event signal_deliver: OK
[   37.232581] Testing event signal_overflow_fail: OK
[   37.252582] Testing event signal_lose_info: OK
[   37.272583] Testing event timer_init: OK
[   37.292585] Testing event timer_start: OK
[   37.312656] Testing event timer_expire_entry: OK
[   37.332588] Testing event timer_expire_exit: OK
[   37.352581] Testing event timer_cancel: OK
[   37.372713] Testing event hrtimer_init: OK
[   37.392585] Testing event hrtimer_start: OK
[   37.412587] Testing event hrtimer_expire_entry: OK
[   37.432579] Testing event hrtimer_expire_exit: OK
[   37.452581] Testing event hrtimer_cancel: OK
[   37.472644] Testing event itimer_state: OK
[   37.492602] Testing event itimer_expire: OK
[   37.512604] Testing event irq_handler_entry: OK
[   37.532580] Testing event irq_handler_exit: OK
[   37.552581] Testing event softirq_entry: OK
[   37.572582] Testing event softirq_exit: OK
[   37.592584] Testing event softirq_raise: OK
[   37.612941] Testing event sched_kthread_stop: OK
[   37.632580] Testing event sched_kthread_stop_ret: OK
[   37.652582] Testing event sched_wakeup: OK
[   37.672565] Testing event sched_wakeup_new: OK
[   37.692557] Testing event sched_switch: OK
[   37.712567] Testing event sched_migrate_task: OK
[   37.732587] Testing event sched_process_free: OK
[   37.752580] Testing event sched_process_exit: OK
[   37.772581] Testing event sched_wait_task: OK
[   37.792583] Testing event sched_process_wait: OK
[   37.812585] Testing event sched_process_fork: OK
[   37.832587] Testing event sched_stat_wait: OK
[   37.852588] Testing event sched_stat_sleep: OK
[   37.872581] Testing event sched_stat_iowait: OK
[   37.892583] Testing event sched_stat_runtime: OK
[   37.912586] Testing event sched_pi_setprio: OK
[   37.932587] Testing event sys_enter: OK
[   37.952598] Testing event sys_exit: OK
[   37.972599] Running tests on trace event systems:
[   37.976007] Testing event system skb: OK
[   37.996725] Testing event system net: OK
[   38.016762] Testing event system napi: OK
[   38.036615] Testing event system scsi: OK
[   38.056766] Testing event system drm: OK
[   38.076707] Testing event system bkl: OK
[   38.096638] Testing event system block: OK
[   38.117367] Testing event system writeback: OK
[   38.137352] Testing event system kmem: OK
[   38.244779] Testing event system vmscan: OK
[   38.264972] Testing event system power: OK
[   38.284852] Testing event system lock: OK
[   38.304853] Testing event system workqueue: OK
[   38.324646] Testing event system signal: OK
[   38.344726] Testing event system timer: OK
[   38.365403] Testing event system irq: OK
[   38.385144] Testing event system sched: OK
[   38.405199] Testing event system raw_syscalls: OK
[   38.424656] Running tests on all trace events:
[   38.428006] Testing all events: OK
[   38.604658] Running tests again, along with the function tracer
[   38.608024] Running tests on trace events:
[   38.612134] Testing event kfree_skb: OK
[   38.633441] Testing event consume_skb: OK
[   38.653288] Testing event skb_copy_datagram_iovec: OK
[   38.673296] Testing event net_dev_xmit: OK
[   38.693370] Testing event net_dev_queue: OK
[   38.713292] Testing event netif_receive_skb: OK
[   38.733295] Testing event netif_rx: OK
[   38.753295] Testing event napi_poll: OK
[   38.773367] Testing event scsi_dispatch_cmd_start: OK
[   38.793290] Testing event scsi_dispatch_cmd_error: OK
[   38.813302] Testing event scsi_dispatch_cmd_done: OK
[   38.833293] Testing event scsi_dispatch_cmd_timeout: OK
[   38.853296] Testing event scsi_eh_wakeup: 
[   38.872207] test-events used greatest stack depth: 6920 bytes left
[   38.876528] OK
[   38.880025] Testing event drm_vblank_event: OK
[   38.901299] Testing event drm_vblank_event_queued: OK
[   38.921290] Testing event drm_vblank_event_delivered: OK
[   38.941369] Testing event lock_kernel: OK
[   38.961294] Testing event unlock_kernel: OK
[   38.981288] Testing event block_rq_abort: OK
[   39.001297] Testing event block_rq_requeue: OK
[   39.021289] Testing event block_rq_complete: OK
[   39.041293] Testing event block_rq_insert: OK
[   39.061295] Testing event block_rq_issue: OK
[   39.081294] Testing event block_bio_bounce: OK
[   39.101289] Testing event block_bio_complete: OK
[   39.121211] Testing event block_bio_backmerge: OK
[   39.141292] Testing event block_bio_frontmerge: OK
[   39.161294] Testing event block_bio_queue: OK
[   39.181295] Testing event block_getrq: OK
[   39.201288] Testing event block_sleeprq: OK
[   39.221290] Testing event block_plug: OK
[   39.241292] Testing event block_unplug_timer: OK
[   39.261293] Testing event block_unplug_io: OK
[   39.281372] Testing event block_split: OK
[   39.301287] Testing event block_remap: OK
[   39.321367] Testing event block_rq_remap: OK
[   39.341213] Testing event writeback_nothread: OK
[   39.361293] Testing event writeback_queue: OK
[   39.381295] Testing event writeback_exec: OK
[   39.401289] Testing event writeback_pages_written: OK
[   39.421297] Testing event writeback_nowork: OK
[   39.441290] Testing event writeback_wake_thread: OK
[   39.461294] Testing event writeback_wake_forker_thread: OK
[   39.481295] Testing event writeback_bdi_register: OK
[   39.501288] Testing event writeback_bdi_unregister: OK
[   39.521287] Testing event writeback_thread_start: OK
[   39.541291] Testing event writeback_thread_stop: OK
[   39.561292] Testing event wbc_writeback_start: OK
[   39.581286] Testing event wbc_writeback_written: OK
[   39.601295] Testing event wbc_writeback_wait: OK
[   39.621290] Testing event wbc_balance_dirty_start: OK
[   39.641289] Testing event wbc_balance_dirty_written: OK
[   39.661292] Testing event wbc_balance_dirty_wait: OK
[   39.681292] Testing event wbc_writepage: OK
[   39.701294] Testing event kmalloc: OK
[   40.057226] Testing event kmem_cache_alloc: OK
[   40.077287] Testing event kmalloc_node: OK
[   40.097368] Testing event kmem_cache_alloc_node: OK
[   40.117274] Testing event kfree: OK
[   40.137292] Testing event kmem_cache_free: OK
[   40.157293] Testing event mm_page_free_direct: OK
[   40.177287] Testing event mm_pagevec_free: OK
[   40.197297] Testing event mm_page_alloc: OK
[   40.217353] Testing event mm_page_alloc_zone_locked: OK
[   40.237294] Testing event mm_page_pcpu_drain: OK
[   40.257287] Testing event mm_page_alloc_extfrag: OK
[   40.277297] Testing event mm_vmscan_kswapd_sleep: OK
[   40.297288] Testing event mm_vmscan_kswapd_wake: OK
[   40.317352] Testing event mm_vmscan_wakeup_kswapd: OK
[   40.337293] Testing event mm_vmscan_direct_reclaim_begin: OK
[   40.357293] Testing event mm_vmscan_memcg_reclaim_begin: OK
[   40.377219] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[   40.401215] Testing event mm_vmscan_direct_reclaim_end: OK
[   40.421294] Testing event mm_vmscan_memcg_reclaim_end: OK
[   40.441211] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[   40.465215] Testing event mm_vmscan_lru_isolate: OK
[   40.485293] Testing event mm_vmscan_memcg_isolate: OK
[   40.505219] Testing event mm_vmscan_writepage: OK
[   40.525289] Testing event power_start: OK
[   40.545523] Testing event power_frequency: OK
[   40.565293] Testing event power_end: OK
[   40.585373] Testing event clock_enable: OK
[   40.605220] Testing event clock_disable: OK
[   40.625220] Testing event clock_set_rate: OK
[   40.645231] Testing event power_domain_target: OK
[   40.665216] Testing event lock_acquire: OK
[   40.685459] Testing event lock_release: OK
[   40.705443] Testing event lock_contended: OK
[   40.725299] Testing event lock_acquired: OK
[   40.745421] Testing event workqueue_execute_start: OK
[   40.765293] Testing event workqueue_execute_end: OK
[   40.785303] Testing event signal_generate: OK
[   40.805339] Testing event signal_deliver: OK
[   40.825296] Testing event signal_overflow_fail: OK
[   40.845290] Testing event signal_lose_info: OK
[   40.865300] Testing event timer_init: OK
[   40.885295] Testing event timer_start: OK
[   40.905608] Testing event timer_expire_entry: OK
[   40.925298] Testing event timer_expire_exit: OK
[   40.945297] Testing event timer_cancel: OK
[   40.965838] Testing event hrtimer_init: OK
[   40.985293] Testing event hrtimer_start: OK
[   41.005294] Testing event hrtimer_expire_entry: OK
[   41.025295] Testing event hrtimer_expire_exit: OK
[   41.045289] Testing event hrtimer_cancel: OK
[   41.065524] Testing event itimer_state: OK
[   41.085379] Testing event itimer_expire: OK
[   41.105373] Testing event irq_handler_entry: OK
[   41.125297] Testing event irq_handler_exit: OK
[   41.145297] Testing event softirq_entry: OK
[   41.165291] Testing event softirq_exit: OK
[   41.185292] Testing event softirq_raise: OK
[   41.206755] Testing event sched_kthread_stop: OK
[   41.229300] Testing event sched_kthread_stop_ret: OK
[   41.249291] Testing event sched_wakeup: OK
[   41.269217] Testing event sched_wakeup_new: OK
[   41.289210] Testing event sched_switch: OK
[   41.309221] Testing event sched_migrate_task: OK
[   41.329291] Testing event sched_process_free: OK
[   41.349301] Testing event sched_process_exit: OK
[   41.369293] Testing event sched_wait_task: OK
[   41.389296] Testing event sched_process_wait: OK
[   41.409296] Testing event sched_process_fork: OK
[   41.429299] Testing event sched_stat_wait: OK
[   41.449293] Testing event sched_stat_sleep: OK
[   41.469294] Testing event sched_stat_iowait: OK
[   41.489293] Testing event sched_stat_runtime: OK
[   41.509296] Testing event sched_pi_setprio: OK
[   41.529290] Testing event sys_enter: OK
[   41.549302] Testing event sys_exit: OK
[   41.569302] Running tests on trace event systems:
[   41.572028] Testing event system skb: OK
[   41.593855] Testing event system net: OK
[   41.613960] Testing event system napi: OK
[   41.633415] Testing event system scsi: OK
[   41.654041] Testing event system drm: OK
[   41.673775] Testing event system bkl: OK
[   41.693516] Testing event system block: OK
[   41.720625] Testing event system writeback: OK
[   41.748519] Testing event system kmem: OK
[   42.114329] Testing event system vmscan: OK
[   42.138950] Testing event system power: OK
[   42.162412] Testing event system lock: OK
[   42.186206] Testing event system workqueue: OK
[   42.205518] Testing event system signal: OK
[   42.225874] Testing event system timer: OK
[   42.252634] Testing event system irq: OK
[   42.275528] Testing event system sched: OK
[   42.299855] Testing event system raw_syscalls: OK
[   42.321523] Running tests on all trace events:
[   42.324027] Testing all events: 
[  245.668090] INFO: task swapper:1 blocked for more than 120 seconds.
[  245.672051] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  245.676026] swapper       D f6420b40  6544     1      0 0x00000000
[  245.684051]  f6437dac 00000046 f694aac0 f6420b40 f6438000 f6437d74 f6438294 f6438290
[  245.692237]  c2192ac0 c204e6c0 c2192ac0 c2192ac0 f6438290 00000000 f6438000 ff2ffa7d
[  245.701068]  00000009 f6420b40 f6437e5c 7fffffff f6438000 f6437dfc f6437e5c 7fffffff
[  245.709071] Call Trace:
[  245.711551]  [<c1a7f561>] schedule_timeout+0x1c/0x1e7
[  245.712036]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
[  245.716037]  [<c1027f2d>] ? sub_preempt_count+0x4/0x98
[  245.720061]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
[  245.724036]  [<c1027fb4>] ? sub_preempt_count+0x8b/0x98
[  245.728036]  [<c1a7e76b>] wait_for_common+0xc1/0x11a
[  245.732062]  [<c102de32>] ? default_wake_function+0x0/0x12
[  245.736041]  [<c1a7e863>] wait_for_completion+0x17/0x19
[  245.740069]  [<c10667a2>] __stop_cpus+0xdd/0x103
[  245.744072]  [<c1a7e6db>] ? wait_for_common+0x31/0x11a
[  245.748040]  [<c10665a4>] ? stop_machine_cpu_stop+0x0/0x9a
[  245.752040]  [<c106683d>] stop_cpus+0x2c/0x3f
[  245.756069]  [<c10668af>] __stop_machine+0x5f/0x67
[  245.760186]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
[  245.764040]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
[  245.768071]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
[  245.772040]  [<c10060fd>] text_poke_smp+0x3a/0x42
[  245.776039]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
[  245.780098]  [<c1005b9c>] arch_jump_label_transform+0x53/0x67
[  245.784042]  [<c104ef0d>] jump_label_update+0x49/0x98
[  245.788041]  [<c1070b33>] tracepoint_update_probe_range+0xec/0x116
[  245.792070]  [<c1070c74>] tracepoint_probe_unregister+0x51/0x6b
[  245.796040]  [<c107f3c0>] ftrace_event_reg+0x48/0x4c
[  245.800041]  [<c107e87c>] ftrace_event_enable_disable+0x39/0x8a
[  245.804070]  [<c107ebdf>] __ftrace_set_clr_event+0x91/0xbc
[  245.808043]  [<c1fbee72>] event_trace_self_tests+0x1cd/0x239
[  245.812040]  [<c1fbf025>] event_trace_self_tests_init+0x2a/0x39
[  245.816230]  [<c1fab282>] do_one_initcall+0x47/0x113
[  245.820069]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
[  245.824040]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
[  245.828069]  [<c1fab477>] kernel_init+0x10d/0x18e
[  245.832040]  [<c1fab36a>] ? kernel_init+0x0/0x18e
[  245.836040]  [<c1002c7e>] kernel_thread_helper+0x6/0x10
[  245.840060] 5 locks held by swapper/1:
[  245.844028]  #0:  (event_mutex){......}, at: [<c107eb6a>] __ftrace_set_clr_event+0x1c/0xbc
[  245.852058]  #1:  (tracepoints_mutex){......}, at: [<c1070a6e>] tracepoint_update_probe_range+0x27/0x116
[  245.860195]  #2:  (jump_label_mutex){......}, at: [<c104eee3>] jump_label_update+0x1f/0x98
[  245.872028]  #3:  (text_mutex){......}, at: [<c1005b8d>] arch_jump_label_transform+0x44/0x67
[  245.880028]  #4:  (stop_cpus_mutex){......}, at: [<c1066831>] stop_cpus+0x20/0x3f
[  324.576593] kworker/u:0 used greatest stack depth: 6484 bytes left
[  365.888113] INFO: task swapper:1 blocked for more than 120 seconds.
[  365.892050] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  365.896026] swapper       D f6420b40  6544     1      0 0x00000000
[  365.904026]  f6437dac 00000046 f694aac0 f6420b40 f6438000 f6437d74 f6438294 f6438290
[  365.912254]  c2192ac0 c204e6c0 c2192ac0 c2192ac0 f6438290 00000000 f6438000 ff2ffa7d
[  365.921041]  00000009 f6420b40 f6437e5c 7fffffff f6438000 f6437dfc f6437e5c 7fffffff
[  365.929044] Call Trace:
[  365.931527]  [<c1a7f561>] schedule_timeout+0x1c/0x1e7
[  365.932060]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
[  365.936061]  [<c1027f2d>] ? sub_preempt_count+0x4/0x98
[  365.940036]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
[  365.944036]  [<c1027fb4>] ? sub_preempt_count+0x8b/0x98
[  365.948061]  [<c1a7e76b>] wait_for_common+0xc1/0x11a
[  365.952036]  [<c102de32>] ? default_wake_function+0x0/0x12
[  365.956035]  [<c1a7e863>] wait_for_completion+0x17/0x19
[  365.960060]  [<c10667a2>] __stop_cpus+0xdd/0x103
[  365.964038]  [<c1a7e6db>] ? wait_for_common+0x31/0x11a
[  365.968035]  [<c10665a4>] ? stop_machine_cpu_stop+0x0/0x9a
[  365.972085]  [<c106683d>] stop_cpus+0x2c/0x3f
[  365.976035]  [<c10668af>] __stop_machine+0x5f/0x67
[  365.980035]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
[  365.984061]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
[  365.988036]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
[  365.992035]  [<c10060fd>] text_poke_smp+0x3a/0x42
[  365.996069]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
[  366.000324]  [<c1005b9c>] arch_jump_label_transform+0x53/0x67
[  366.004042]  [<c104ef0d>] jump_label_update+0x49/0x98
[  366.008070]  [<c1070b33>] tracepoint_update_probe_range+0xec/0x116
[  366.012069]  [<c1070c74>] tracepoint_probe_unregister+0x51/0x6b
[  366.016040]  [<c107f3c0>] ftrace_event_reg+0x48/0x4c
[  366.020070]  [<c107e87c>] ftrace_event_enable_disable+0x39/0x8a
[  366.024041]  [<c107ebdf>] __ftrace_set_clr_event+0x91/0xbc
[  366.028042]  [<c1fbee72>] event_trace_self_tests+0x1cd/0x239
[  366.032069]  [<c1fbf025>] event_trace_self_tests_init+0x2a/0x39
[  366.036040]  [<c1fab282>] do_one_initcall+0x47/0x113
[  366.040040]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
[  366.044069]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
[  366.048040]  [<c1fab477>] kernel_init+0x10d/0x18e
[  366.052068]  [<c1fab36a>] ? kernel_init+0x0/0x18e
[  366.056069]  [<c1002c7e>] kernel_thread_helper+0x6/0x10
[  366.060031] 5 locks held by swapper/1:
[  366.064029]  #0:  (event_mutex){......}, at: [<c107eb6a>] __ftrace_set_clr_event+0x1c/0xbc
[  366.072029]  #1:  (tracepoints_mutex){......}, at: [<c1070a6e>] tracepoint_update_probe_range+0x27/0x116
[  366.080058]  #2:  (jump_label_mutex){......}, at: [<c104eee3>] jump_label_update+0x1f/0x98
[  366.092086]  #3:  (text_mutex){......}, at: [<c1005b8d>] arch_jump_label_transform+0x44/0x67
[  366.100166]  #4:  (stop_cpus_mutex){......}, at: [<c1066831>] stop_cpus+0x20/0x3f
[  486.108087] INFO: task swapper:1 blocked for more than 120 seconds.
[  486.112027] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  486.116051] swapper       D f6420b40  6544     1      0 0x00000000
[  486.124026]  f6437dac 00000046 f694aac0 f6420b40 f6438000 f6437d74 f6438294 f6438290
[  486.132232]  c2192ac0 c204e6c0 c2192ac0 c2192ac0 f6438290 00000000 f6438000 ff2ffa7d
[  486.140411]  00000009 f6420b40 f6437e5c 7fffffff f6438000 f6437dfc f6437e5c 7fffffff
[  486.149040] Call Trace:
[  486.151516]  [<c1a7f561>] schedule_timeout+0x1c/0x1e7
[  486.152061]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
[  486.156035]  [<c1027f2d>] ? sub_preempt_count+0x4/0x98
[  486.160035]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
[  486.164061]  [<c1027fb4>] ? sub_preempt_count+0x8b/0x98
[  486.168035]  [<c1a7e76b>] wait_for_common+0xc1/0x11a
[  486.172036]  [<c102de32>] ? default_wake_function+0x0/0x12
[  486.176061]  [<c1a7e863>] wait_for_completion+0x17/0x19
[  486.180060]  [<c10667a2>] __stop_cpus+0xdd/0x103
[  486.184037]  [<c1a7e6db>] ? wait_for_common+0x31/0x11a
[  486.188060]  [<c10665a4>] ? stop_machine_cpu_stop+0x0/0x9a
[  486.192035]  [<c106683d>] stop_cpus+0x2c/0x3f
[  486.196035]  [<c10668af>] __stop_machine+0x5f/0x67
[  486.200060]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
[  486.204035]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
[  486.208041]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
[  486.212070]  [<c10060fd>] text_poke_smp+0x3a/0x42
[  486.216039]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
[  486.220070]  [<c1005b9c>] arch_jump_label_transform+0x53/0x67
[  486.224070]  [<c104ef0d>] jump_label_update+0x49/0x98
[  486.228041]  [<c1070b33>] tracepoint_update_probe_range+0xec/0x116
[  486.232041]  [<c1070c74>] tracepoint_probe_unregister+0x51/0x6b
[  486.236069]  [<c107f3c0>] ftrace_event_reg+0x48/0x4c
[  486.240179]  [<c107e87c>] ftrace_event_enable_disable+0x39/0x8a
[  486.244041]  [<c107ebdf>] __ftrace_set_clr_event+0x91/0xbc
[  486.248071]  [<c1fbee72>] event_trace_self_tests+0x1cd/0x239
[  486.252041]  [<c1fbf025>] event_trace_self_tests_init+0x2a/0x39
[  486.256040]  [<c1fab282>] do_one_initcall+0x47/0x113
[  486.260098]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
[  486.264040]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
[  486.268041]  [<c1fab477>] kernel_init+0x10d/0x18e
[  486.272069]  [<c1fab36a>] ? kernel_init+0x0/0x18e
[  486.276040]  [<c1002c7e>] kernel_thread_helper+0x6/0x10
[  486.280031] 5 locks held by swapper/1:
[  486.284058]  #0:  (event_mutex){......}, at: [<c107eb6a>] __ftrace_set_clr_event+0x1c/0xbc
[  486.292029]  #1:  (tracepoints_mutex){......}, at: [<c1070a6e>] tracepoint_update_probe_range+0x27/0x116
[  486.300057]  #2:  (jump_label_mutex){......}, at: [<c104eee3>] jump_label_update+0x1f/0x98
[  486.311742]  #3:  (text_mutex){......}, at: [<c1005b8d>] arch_jump_label_transform+0x44/0x67
[  486.320058]  #4:  (stop_cpus_mutex){......}, at: [<c1066831>] stop_cpus+0x20/0x3f
[  606.328087] INFO: task swapper:1 blocked for more than 120 seconds.
[  606.332051] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  606.336026] swapper       D f6420b40  6544     1      0 0x00000000
[  606.344051]  f6437dac 00000046 f694aac0 f6420b40 f6438000 f6437d74 f6438294 f6438290
[  606.352229]  c2192ac0 c204e6c0 c2192ac0 c2192ac0 f6438290 00000000 f6438000 ff2ffa7d
[  606.360229]  00000009 f6420b40 f6437e5c 7fffffff f6438000 f6437dfc f6437e5c 7fffffff
[  606.368255] Call Trace:
[  606.370731]  [<c1a7f561>] schedule_timeout+0x1c/0x1e7
[  606.372035]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
[  606.376035]  [<c1027f2d>] ? sub_preempt_count+0x4/0x98
[  606.380187]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
[  606.384036]  [<c1027fb4>] ? sub_preempt_count+0x8b/0x98
[  606.388035]  [<c1a7e76b>] wait_for_common+0xc1/0x11a
[  606.392062]  [<c102de32>] ? default_wake_function+0x0/0x12
[  606.396061]  [<c1a7e863>] wait_for_completion+0x17/0x19
[  606.400034]  [<c10667a2>] __stop_cpus+0xdd/0x103
[  606.404063]  [<c1a7e6db>] ? wait_for_common+0x31/0x11a
[  606.408035]  [<c10665a4>] ? stop_machine_cpu_stop+0x0/0x9a
[  606.412035]  [<c106683d>] stop_cpus+0x2c/0x3f
[  606.416061]  [<c10668af>] __stop_machine+0x5f/0x67
[  606.420035]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
[  606.424035]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
[  606.428070]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
[  606.432040]  [<c10060fd>] text_poke_smp+0x3a/0x42
[  606.436068]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
[  606.440070]  [<c1005b9c>] arch_jump_label_transform+0x53/0x67
[  606.444041]  [<c104ef0d>] jump_label_update+0x49/0x98
[  606.448041]  [<c1070b33>] tracepoint_update_probe_range+0xec/0x116
[  606.452070]  [<c1070c74>] tracepoint_probe_unregister+0x51/0x6b
[  606.456040]  [<c107f3c0>] ftrace_event_reg+0x48/0x4c
[  606.460041]  [<c107e87c>] ftrace_event_enable_disable+0x39/0x8a
[  606.464070]  [<c107ebdf>] __ftrace_set_clr_event+0x91/0xbc
[  606.468042]  [<c1fbee72>] event_trace_self_tests+0x1cd/0x239
[  606.472041]  [<c1fbf025>] event_trace_self_tests_init+0x2a/0x39
[  606.476098]  [<c1fab282>] do_one_initcall+0x47/0x113
[  606.480179]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
[  606.484040]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
[  606.488070]  [<c1fab477>] kernel_init+0x10d/0x18e
[  606.492040]  [<c1fab36a>] ? kernel_init+0x0/0x18e
[  606.496040]  [<c1002c7e>] kernel_thread_helper+0x6/0x10
[  606.500060] 5 locks held by swapper/1:
[  606.504029]  #0:  (event_mutex){......}, at: [<c107eb6a>] __ftrace_set_clr_event+0x1c/0xbc
[  606.512058]  #1:  (tracepoints_mutex){......}, at: [<c1070a6e>] tracepoint_update_probe_range+0x27/0x116
[  606.520029]  #2:  (jump_label_mutex){......}, at: [<c104eee3>] jump_label_update+0x1f/0x98
[  606.531719]  #3:  (text_mutex){......}, at: [<c1005b8d>] arch_jump_label_transform+0x44/0x67
[  606.540029]  #4:  (stop_cpus_mutex){......}, at: [<c1066831>] stop_cpus+0x20/0x3f
[  726.548112] INFO: task swapper:1 blocked for more than 120 seconds.
[  726.552025] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  726.556026] swapper       D f6420b40  6544     1      0 0x00000000
[  726.564026]  f6437dac 00000046 f694aac0 f6420b40 f6438000 f6437d74 f6438294 f6438290
[  726.572254]  c2192ac0 c204e6c0 c2192ac0 c2192ac0 f6438290 00000000 f6438000 ff2ffa7d
[  726.580256]  00000009 f6420b40 f6437e5c 7fffffff f6438000 f6437dfc f6437e5c 7fffffff
[  726.589045] Call Trace:
[  726.591527]  [<c1a7f561>] schedule_timeout+0x1c/0x1e7
[  726.592035]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
[  726.596061]  [<c1027f2d>] ? sub_preempt_count+0x4/0x98
[  726.600036]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
[  726.604036]  [<c1027fb4>] ? sub_preempt_count+0x8b/0x98
[  726.608061]  [<c1a7e76b>] wait_for_common+0xc1/0x11a
[  726.612036]  [<c102de32>] ? default_wake_function+0x0/0x12
[  726.616036]  [<c1a7e863>] wait_for_completion+0x17/0x19
[  726.620211]  [<c10667a2>] __stop_cpus+0xdd/0x103
[  726.624038]  [<c1a7e6db>] ? wait_for_common+0x31/0x11a
[  726.628035]  [<c10665a4>] ? stop_machine_cpu_stop+0x0/0x9a
[  726.632060]  [<c106683d>] stop_cpus+0x2c/0x3f
[  726.636035]  [<c10668af>] __stop_machine+0x5f/0x67
[  726.640035]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
[  726.644061]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
[  726.648041]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
[  726.652040]  [<c10060fd>] text_poke_smp+0x3a/0x42
[  726.656069]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
[  726.660070]  [<c1005b9c>] arch_jump_label_transform+0x53/0x67
[  726.664041]  [<c104ef0d>] jump_label_update+0x49/0x98
[  726.668070]  [<c1070b33>] tracepoint_update_probe_range+0xec/0x116
[  726.672041]  [<c1070c74>] tracepoint_probe_unregister+0x51/0x6b
[  726.676040]  [<c107f3c0>] ftrace_event_reg+0x48/0x4c
[  726.680070]  [<c107e87c>] ftrace_event_enable_disable+0x39/0x8a
[  726.684041]  [<c107ebdf>] __ftrace_set_clr_event+0x91/0xbc
[  726.688041]  [<c1fbee72>] event_trace_self_tests+0x1cd/0x239
[  726.692070]  [<c1fbf025>] event_trace_self_tests_init+0x2a/0x39
[  726.696040]  [<c1fab282>] do_one_initcall+0x47/0x113
[  726.700069]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
[  726.704070]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
[  726.708040]  [<c1fab477>] kernel_init+0x10d/0x18e
[  726.712040]  [<c1fab36a>] ? kernel_init+0x0/0x18e
[  726.716069]  [<c1002c7e>] kernel_thread_helper+0x6/0x10
[  726.720170] 5 locks held by swapper/1:
[  726.724029]  #0:  (event_mutex){......}, at: [<c107eb6a>] __ftrace_set_clr_event+0x1c/0xbc
[  726.732029]  #1:  (tracepoints_mutex){......}, at: [<c1070a6e>] tracepoint_update_probe_range+0x27/0x116
[  726.740086]  #2:  (jump_label_mutex){......}, at: [<c104eee3>] jump_label_update+0x1f/0x98
[  726.751716]  #3:  (text_mutex){......}, at: [<c1005b8d>] arch_jump_label_transform+0x44/0x67
[  726.760029]  #4:  (stop_cpus_mutex){......}, at: [<c1066831>] stop_cpus+0x20/0x3f
[  846.768087] INFO: task swapper:1 blocked for more than 120 seconds.
[  846.772025] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  846.776051] swapper       D f6420b40  6544     1      0 0x00000000
[  846.784026]  f6437dac 00000046 f694aac0 f6420b40 f6438000 f6437d74 f6438294 f6438290
[  846.792228]  c2192ac0 c204e6c0 c2192ac0 c2192ac0 f6438290 00000000 f6438000 ff2ffa7d
[  846.800257]  00000009 f6420b40 f6437e5c 7fffffff f6438000 f6437dfc f6437e5c 7fffffff
[  846.808228] Call Trace:
[  846.810704]  [<c1a7f561>] schedule_timeout+0x1c/0x1e7
[  846.812061]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
[  846.816035]  [<c1027f2d>] ? sub_preempt_count+0x4/0x98
[  846.820061]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
[  846.824061]  [<c1027fb4>] ? sub_preempt_count+0x8b/0x98
[  846.828035]  [<c1a7e76b>] wait_for_common+0xc1/0x11a
[  846.832036]  [<c102de32>] ? default_wake_function+0x0/0x12
[  846.836061]  [<c1a7e863>] wait_for_completion+0x17/0x19
[  846.840034]  [<c10667a2>] __stop_cpus+0xdd/0x103
[  846.844037]  [<c1a7e6db>] ? wait_for_common+0x31/0x11a
[  846.848060]  [<c10665a4>] ? stop_machine_cpu_stop+0x0/0x9a
[  846.852035]  [<c106683d>] stop_cpus+0x2c/0x3f
[  846.856036]  [<c10668af>] __stop_machine+0x5f/0x67
[  846.860211]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
[  846.864035]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
[  846.868035]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
[  846.872061]  [<c10060fd>] text_poke_smp+0x3a/0x42
[  846.876039]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
[  846.880041]  [<c1005b9c>] arch_jump_label_transform+0x53/0x67
[  846.884070]  [<c104ef0d>] jump_label_update+0x49/0x98
[  846.888041]  [<c1070b33>] tracepoint_update_probe_range+0xec/0x116
[  846.892041]  [<c1070c74>] tracepoint_probe_unregister+0x51/0x6b
[  846.896069]  [<c107f3c0>] ftrace_event_reg+0x48/0x4c
[  846.900069]  [<c107e87c>] ftrace_event_enable_disable+0x39/0x8a
[  846.904041]  [<c107ebdf>] __ftrace_set_clr_event+0x91/0xbc
[  846.908071]  [<c1fbee72>] event_trace_self_tests+0x1cd/0x239
[  846.912041]  [<c1fbf025>] event_trace_self_tests_init+0x2a/0x39
[  846.916040]  [<c1fab282>] do_one_initcall+0x47/0x113
[  846.920069]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
[  846.928045]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
[  846.932066]  [<c1fab477>] kernel_init+0x10d/0x18e
[  846.936040]  [<c1fab36a>] ? kernel_init+0x0/0x18e
[  846.940069]  [<c1002c7e>] kernel_thread_helper+0x6/0x10
[  846.944060] 5 locks held by swapper/1:
[  846.948029]  #0:  (event_mutex){......}, at: [<c107eb6a>] __ftrace_set_clr_event+0x1c/0xbc
[  846.956058]  #1:  (tracepoints_mutex){......}, at: [<c1070a6e>] tracepoint_update_probe_range+0x27/0x116
[  846.964029]  #2:  (jump_label_mutex){......}, at: [<c104eee3>] jump_label_update+0x1f/0x98
[  846.975709]  #3:  (text_mutex){......}, at: [<c1005b8d>] arch_jump_label_transform+0x44/0x67
[  846.984029]  #4:  (stop_cpus_mutex){......}, at: [<c1066831>] stop_cpus+0x20/0x3f
[  966.992112] INFO: task swapper:1 blocked for more than 120 seconds.
[  966.996025] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  967.000275] swapper       D f6420b40  6544     1      0 0x00000000
[  967.008026]  f6437dac 00000046 f694aac0 f6420b40 f6438000 f6437d74 f6438294 f6438290
[  967.017042]  c2192ac0 c204e6c0 c2192ac0 c2192ac0 f6438290 00000000 f6438000 ff2ffa7d
[  967.025044]  00000009 f6420b40 f6437e5c 7fffffff f6438000 f6437dfc f6437e5c 7fffffff
[  967.033044] Call Trace:
[  967.035520]  [<c1a7f561>] schedule_timeout+0x1c/0x1e7
[  967.036035]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
[  967.040061]  [<c1027f2d>] ? sub_preempt_count+0x4/0x98
[  967.044036]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
[  967.048036]  [<c1027fb4>] ? sub_preempt_count+0x8b/0x98
[  967.052061]  [<c1a7e76b>] wait_for_common+0xc1/0x11a
[  967.056036]  [<c102de32>] ? default_wake_function+0x0/0x12
[  967.060061]  [<c1a7e863>] wait_for_completion+0x17/0x19
[  967.064060]  [<c10667a2>] __stop_cpus+0xdd/0x103
[  967.068038]  [<c1a7e6db>] ? wait_for_common+0x31/0x11a
[  967.072035]  [<c10665a4>] ? stop_machine_cpu_stop+0x0/0x9a
[  967.076060]  [<c106683d>] stop_cpus+0x2c/0x3f
[  967.080035]  [<c10668af>] __stop_machine+0x5f/0x67
[  967.084035]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
[  967.088061]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
[  967.092041]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
[  967.096040]  [<c10060fd>] text_poke_smp+0x3a/0x42
[  967.100236]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
[  967.104041]  [<c1005b9c>] arch_jump_label_transform+0x53/0x67
[  967.108041]  [<c104ef0d>] jump_label_update+0x49/0x98
[  967.112070]  [<c1070b33>] tracepoint_update_probe_range+0xec/0x116
[  967.116041]  [<c1070c74>] tracepoint_probe_unregister+0x51/0x6b
[  967.120040]  [<c107f3c0>] ftrace_event_reg+0x48/0x4c
[  967.124070]  [<c107e87c>] ftrace_event_enable_disable+0x39/0x8a
[  967.128041]  [<c107ebdf>] __ftrace_set_clr_event+0x91/0xbc
[  967.132042]  [<c1fbee72>] event_trace_self_tests+0x1cd/0x239
[  967.136070]  [<c1fbf025>] event_trace_self_tests_init+0x2a/0x39
[  967.140069]  [<c1fab282>] do_one_initcall+0x47/0x113
[  967.144040]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
[  967.148070]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
[  967.152041]  [<c1fab477>] kernel_init+0x10d/0x18e
[  967.156040]  [<c1fab36a>] ? kernel_init+0x0/0x18e
[  967.164032]  [<c1002c7e>] kernel_thread_helper+0x6/0x10
[  967.168031] 5 locks held by swapper/1:
[  967.172058]  #0:  (event_mutex){......}, at: [<c107eb6a>] __ftrace_set_clr_event+0x1c/0xbc
[  967.180057]  #1:  (tracepoints_mutex){......}, at: [<c1070a6e>] tracepoint_update_probe_range+0x27/0x116
[  967.188029]  #2:  (jump_label_mutex){......}, at: [<c104eee3>] jump_label_update+0x1f/0x98
[  967.200158]  #3:  (text_mutex){......}, at: [<c1005b8d>] arch_jump_label_transform+0x44/0x67
[  967.208058]  #4:  (stop_cpus_mutex){......}, at: [<c1066831>] stop_cpus+0x20/0x3f
[ 1087.216087] INFO: task swapper:1 blocked for more than 120 seconds.
[ 1087.220076] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1087.224026] swapper       D f6420b40  6544     1      0 0x00000000
[ 1087.232051]  f6437dac 00000046 f694aac0 f6420b40 f6438000 f6437d74 f6438294 f6438290
[ 1087.240358]  c2192ac0 c204e6c0 c2192ac0 c2192ac0 f6438290 00000000 f6438000 ff2ffa7d
[ 1087.249034]  00000009 f6420b40 f6437e5c 7fffffff f6438000 f6437dfc f6437e5c 7fffffff
[ 1087.257071] Call Trace:
[ 1087.259553]  [<c1a7f561>] schedule_timeout+0x1c/0x1e7
[ 1087.260060]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
[ 1087.264035]  [<c1027f2d>] ? sub_preempt_count+0x4/0x98
[ 1087.268061]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
[ 1087.272037]  [<c1027fb4>] ? sub_preempt_count+0x8b/0x98
[ 1087.276035]  [<c1a7e76b>] wait_for_common+0xc1/0x11a
[ 1087.280061]  [<c102de32>] ? default_wake_function+0x0/0x12
[ 1087.284036]  [<c1a7e863>] wait_for_completion+0x17/0x19
[ 1087.288034]  [<c10667a2>] __stop_cpus+0xdd/0x103
[ 1087.292063]  [<c1a7e6db>] ? wait_for_common+0x31/0x11a
[ 1087.296035]  [<c10665a4>] ? stop_machine_cpu_stop+0x0/0x9a
[ 1087.300060]  [<c106683d>] stop_cpus+0x2c/0x3f
[ 1087.304060]  [<c10668af>] __stop_machine+0x5f/0x67
[ 1087.308035]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
[ 1087.312035]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
[ 1087.316070]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
[ 1087.320040]  [<c10060fd>] text_poke_smp+0x3a/0x42
[ 1087.324039]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
[ 1087.328070]  [<c1005b9c>] arch_jump_label_transform+0x53/0x67
[ 1087.332041]  [<c104ef0d>] jump_label_update+0x49/0x98
[ 1087.336041]  [<c1070b33>] tracepoint_update_probe_range+0xec/0x116
[ 1087.340237]  [<c1070c74>] tracepoint_probe_unregister+0x51/0x6b
[ 1087.344040]  [<c107f3c0>] ftrace_event_reg+0x48/0x4c
[ 1087.348041]  [<c107e87c>] ftrace_event_enable_disable+0x39/0x8a
[ 1087.352070]  [<c107ebdf>] __ftrace_set_clr_event+0x91/0xbc
[ 1087.356042]  [<c1fbee72>] event_trace_self_tests+0x1cd/0x239
[ 1087.360041]  [<c1fbf025>] event_trace_self_tests_init+0x2a/0x39
[ 1087.364070]  [<c1fab282>] do_one_initcall+0x47/0x113
[ 1087.368040]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
[ 1087.372040]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
[ 1087.376070]  [<c1fab477>] kernel_init+0x10d/0x18e
[ 1087.380069]  [<c1fab36a>] ? kernel_init+0x0/0x18e
[ 1087.384040]  [<c1002c7e>] kernel_thread_helper+0x6/0x10
[ 1087.388060] 5 locks held by swapper/1:
[ 1087.392029]  #0:  (event_mutex){......}, at: [<c107eb6a>] __ftrace_set_clr_event+0x1c/0xbc
[ 1087.400058]  #1:  (tracepoints_mutex){......}, at: [<c1070a6e>] tracepoint_update_probe_range+0x27/0x116
[ 1087.408029]  #2:  (jump_label_mutex){......}, at: [<c104eee3>] jump_label_update+0x1f/0x98
[ 1087.419709]  #3:  (text_mutex){......}, at: [<c1005b8d>] arch_jump_label_transform+0x44/0x67
[ 1087.428029]  #4:  (stop_cpus_mutex){......}, at: [<c1066831>] stop_cpus+0x20/0x3f
[ 1207.436112] INFO: task swapper:1 blocked for more than 120 seconds.
[ 1207.440025] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1207.444026] swapper       D f6420b40  6544     1      0 0x00000000
[ 1207.452025]  f6437dac 00000046 f694aac0 f6420b40 f6438000 f6437d74 f6438294 f6438290
[ 1207.460254]  c2192ac0 c204e6c0 c2192ac0 c2192ac0 f6438290 00000000 f6438000 ff2ffa7d
[ 1207.468228]  00000009 f6420b40 f6437e5c 7fffffff f6438000 f6437dfc f6437e5c 7fffffff
[ 1207.477044] Call Trace:
[ 1207.479519]  [<c1a7f561>] schedule_timeout+0x1c/0x1e7
[ 1207.480161]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
[ 1207.484061]  [<c1027f2d>] ? sub_preempt_count+0x4/0x98
[ 1207.488061]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
[ 1207.492036]  [<c1027fb4>] ? sub_preempt_count+0x8b/0x98
[ 1207.496061]  [<c1a7e76b>] wait_for_common+0xc1/0x11a
[ 1207.500036]  [<c102de32>] ? default_wake_function+0x0/0x12
[ 1207.504036]  [<c1a7e863>] wait_for_completion+0x17/0x19
[ 1207.508060]  [<c10667a2>] __stop_cpus+0xdd/0x103
[ 1207.512037]  [<c1a7e6db>] ? wait_for_common+0x31/0x11a
[ 1207.516035]  [<c10665a4>] ? stop_machine_cpu_stop+0x0/0x9a
[ 1207.520060]  [<c106683d>] stop_cpus+0x2c/0x3f
[ 1207.524035]  [<c10668af>] __stop_machine+0x5f/0x67
[ 1207.528060]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
[ 1207.532061]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
[ 1207.536041]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
[ 1207.540040]  [<c10060fd>] text_poke_smp+0x3a/0x42
[ 1207.544069]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
[ 1207.548041]  [<c1005b9c>] arch_jump_label_transform+0x53/0x67
[ 1207.552041]  [<c104ef0d>] jump_label_update+0x49/0x98
[ 1207.556070]  [<c1070b33>] tracepoint_update_probe_range+0xec/0x116
[ 1207.560041]  [<c1070c74>] tracepoint_probe_unregister+0x51/0x6b
[ 1207.564040]  [<c107f3c0>] ftrace_event_reg+0x48/0x4c
[ 1207.568098]  [<c107e87c>] ftrace_event_enable_disable+0x39/0x8a
[ 1207.572041]  [<c107ebdf>] __ftrace_set_clr_event+0x91/0xbc
[ 1207.576042]  [<c1fbee72>] event_trace_self_tests+0x1cd/0x239
[ 1207.580208]  [<c1fbf025>] event_trace_self_tests_init+0x2a/0x39
[ 1207.584040]  [<c1fab282>] do_one_initcall+0x47/0x113
[ 1207.588040]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
[ 1207.592070]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
[ 1207.596041]  [<c1fab477>] kernel_init+0x10d/0x18e
[ 1207.600040]  [<c1fab36a>] ? kernel_init+0x0/0x18e
[ 1207.604069]  [<c1002c7e>] kernel_thread_helper+0x6/0x10
[ 1207.608060] 5 locks held by swapper/1:
[ 1207.612029]  #0:  (event_mutex){......}, at: [<c107eb6a>] __ftrace_set_clr_event+0x1c/0xbc
[ 1207.620029]  #1:  (tracepoints_mutex){......}, at: [<c1070a6e>] tracepoint_update_probe_range+0x27/0x116
[ 1207.628058]  #2:  (jump_label_mutex){......}, at: [<c104eee3>] jump_label_update+0x1f/0x98
[ 1207.639716]  #3:  (text_mutex){......}, at: [<c1005b8d>] arch_jump_label_transform+0x44/0x67
[ 1207.648057]  #4:  (stop_cpus_mutex){......}, at: [<c1066831>] stop_cpus+0x20/0x3f
[ 1327.656087] INFO: task swapper:1 blocked for more than 120 seconds.
[ 1327.660050] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1327.664051] swapper       D f6420b40  6544     1      0 0x00000000
[ 1327.672026]  f6437dac 00000046 f694aac0 f6420b40 f6438000 f6437d74 f6438294 f6438290
[ 1327.680229]  c2192ac0 c204e6c0 c2192ac0 c2192ac0 f6438290 00000000 f6438000 ff2ffa7d
[ 1327.688257]  00000009 f6420b40 f6437e5c 7fffffff f6438000 f6437dfc f6437e5c 7fffffff
[ 1327.697044] Call Trace:
[ 1327.699526]  [<c1a7f561>] schedule_timeout+0x1c/0x1e7
[ 1327.700086]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
[ 1327.704035]  [<c1027f2d>] ? sub_preempt_count+0x4/0x98
[ 1327.708035]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
[ 1327.712062]  [<c1027fb4>] ? sub_preempt_count+0x8b/0x98
[ 1327.716035]  [<c1a7e76b>] wait_for_common+0xc1/0x11a
[ 1327.720162]  [<c102de32>] ? default_wake_function+0x0/0x12
[ 1327.724061]  [<c1a7e863>] wait_for_completion+0x17/0x19
[ 1327.728034]  [<c10667a2>] __stop_cpus+0xdd/0x103
[ 1327.732037]  [<c1a7e6db>] ? wait_for_common+0x31/0x11a
[ 1327.736060]  [<c10665a4>] ? stop_machine_cpu_stop+0x0/0x9a
[ 1327.740060]  [<c106683d>] stop_cpus+0x2c/0x3f
[ 1327.744035]  [<c10668af>] __stop_machine+0x5f/0x67
[ 1327.748060]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
[ 1327.752035]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
[ 1327.756035]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
[ 1327.760061]  [<c10060fd>] text_poke_smp+0x3a/0x42
[ 1327.764039]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
[ 1327.768041]  [<c1005b9c>] arch_jump_label_transform+0x53/0x67
[ 1327.772070]  [<c104ef0d>] jump_label_update+0x49/0x98
[ 1327.776041]  [<c1070b33>] tracepoint_update_probe_range+0xec/0x116
[ 1327.780070]  [<c1070c74>] tracepoint_probe_unregister+0x51/0x6b
[ 1327.784069]  [<c107f3c0>] ftrace_event_reg+0x48/0x4c
[ 1327.788040]  [<c107e87c>] ftrace_event_enable_disable+0x39/0x8a
[ 1327.792041]  [<c107ebdf>] __ftrace_set_clr_event+0x91/0xbc
[ 1327.796071]  [<c1fbee72>] event_trace_self_tests+0x1cd/0x239
[ 1327.800041]  [<c1fbf025>] event_trace_self_tests_init+0x2a/0x39
[ 1327.804040]  [<c1fab282>] do_one_initcall+0x47/0x113
[ 1327.808069]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
[ 1327.812040]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
[ 1327.816041]  [<c1fab477>] kernel_init+0x10d/0x18e
[ 1327.820236]  [<c1fab36a>] ? kernel_init+0x0/0x18e
[ 1327.824040]  [<c1002c7e>] kernel_thread_helper+0x6/0x10
[ 1327.828031] 5 locks held by swapper/1:
[ 1327.832058]  #0:  (event_mutex){......}, at: [<c107eb6a>] __ftrace_set_clr_event+0x1c/0xbc
[ 1327.840029]  #1:  (tracepoints_mutex){......}, at: [<c1070a6e>] tracepoint_update_probe_range+0x27/0x116
[ 1327.848029]  #2:  (jump_label_mutex){......}, at: [<c104eee3>] jump_label_update+0x1f/0x98
[ 1327.859745]  #3:  (text_mutex){......}, at: [<c1005b8d>] arch_jump_label_transform+0x44/0x67
[ 1327.868058]  #4:  (stop_cpus_mutex){......}, at: [<c1066831>] stop_cpus+0x20/0x3f

--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-Wed_Oct_20_08_00_12_CEST_2010.bad"

# 5915856b
#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.36-rc8
# Wed Oct 20 08:00:12 2010
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_KTIME_SCALAR=y
CONFIG_BOOTPARAM_SUPPORT_NOT_WANTED=y
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
# CONFIG_BROKEN_BOOT_ALLOWED4 is not set
# CONFIG_BROKEN_BOOT_DISALLOWED is not set
CONFIG_BROKEN_BOOT_EUROPE=y
CONFIG_BROKEN_BOOT_TITAN=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_LZO=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
CONFIG_KERNEL_LZO=y
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
# CONFIG_GENERIC_HARDIRQS_NO_DEPRECATED is not set
CONFIG_HAVE_SPARSE_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
# CONFIG_AUTO_IRQ_AFFINITY is not set
# CONFIG_IRQ_PER_CPU is not set
# CONFIG_HARDIRQS_SW_RESEND is not set
CONFIG_SPARSE_IRQ=y

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_TRACE=y
CONFIG_RCU_FANOUT=32
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_TREE_RCU_TRACE=y
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=20
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
# CONFIG_CGROUP_NS is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_CGROUP_MEM_RES_CTLR is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
CONFIG_DEBUG_BLK_CGROUP=y
CONFIG_SYSFS_DEPRECATED=y
# CONFIG_SYSFS_DEPRECATED_V2 is not set
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
CONFIG_IPC_NS=y
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
# CONFIG_NET_NS is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_LZO=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_EXTRA_PASS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_PERF_COUNTERS is not set
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y

#
# GCOV-based kernel profiling
#
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBDAF=y
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PADATA=y
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
# CONFIG_INLINE_SPIN_UNLOCK is not set
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
# CONFIG_INLINE_READ_UNLOCK is not set
# CONFIG_INLINE_READ_UNLOCK_BH is not set
# CONFIG_INLINE_READ_UNLOCK_IRQ is not set
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
# CONFIG_INLINE_WRITE_UNLOCK is not set
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
# CONFIG_MUTEX_SPIN_ON_OWNER is not set
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP_SUPPORT=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
CONFIG_MCRUSOE=y
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
# CONFIG_HPET_TIMER is not set
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
# CONFIG_IOMMU_API is not set
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_IRQ_TIME_ACCOUNTING=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
CONFIG_I8K=y
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=y
CONFIG_UP_WANTED_1=y
CONFIG_UP_WANTED_2=y
CONFIG_UP_WANTED=y
CONFIG_SMP=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_HIGHPTE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
CONFIG_CMDLINE_BOOL=y
CONFIG_CMDLINE=""
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_PM_VERBOSE=y
CONFIG_CAN_PM_TRACE=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND_NVS=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_PM_RUNTIME is not set
CONFIG_PM_OPS=y
# CONFIG_ACPI is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# CPUFreq processor drivers
#
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_SPEEDSTEP_ICH is not set
CONFIG_X86_SPEEDSTEP_SMI=y
# CONFIG_X86_P4_CLOCKMOD is not set
CONFIG_X86_CPUFREQ_NFORCE2=y
# CONFIG_X86_LONGRUN is not set
CONFIG_X86_E_POWERSAVER=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y
# CONFIG_CPU_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_GOBIOS=y
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_OLPC=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_CNB20LE_QUIRK=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
CONFIG_PCI_DEBUG=y
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
CONFIG_PCI_IOV=y
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
CONFIG_EISA=y
CONFIG_EISA_VLB_PRIMING=y
CONFIG_EISA_PCI_EISA=y
CONFIG_EISA_VIRTUAL_ROOT=y
# CONFIG_EISA_NAMES is not set
CONFIG_MCA=y
CONFIG_MCA_LEGACY=y
# CONFIG_MCA_PROC_FS is not set
CONFIG_SCx200=y
# CONFIG_SCx200HR_TIMER is not set
CONFIG_OLPC=y
# CONFIG_OLPC_XO1 is not set
CONFIG_OLPC_OPENFIRMWARE=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
CONFIG_PD6729=y
CONFIG_I82092=y
CONFIG_I82365=y
CONFIG_TCIC=y
CONFIG_PCMCIA_PROBE=y
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_FAKE is not set
CONFIG_HOTPLUG_PCI_COMPAQ=y
CONFIG_HOTPLUG_PCI_COMPAQ_NVRAM=y
CONFIG_HOTPLUG_PCI_IBM=y
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_UNIX=y
CONFIG_XFRM=y
# CONFIG_XFRM_USER is not set
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_ASK_IP_FIB_HASH is not set
CONFIG_IP_FIB_TRIE=y
# CONFIG_IP_FIB_HASH is not set
CONFIG_IP_FIB_TRIE_STATS=y
# CONFIG_IP_MULTIPLE_TABLES is not set
# CONFIG_IP_ROUTE_MULTIPATH is not set
# CONFIG_IP_ROUTE_VERBOSE is not set
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
CONFIG_NET_IPIP=y
# CONFIG_NET_IPGRE is not set
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
CONFIG_IPV6_PRIVACY=y
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
CONFIG_INET6_ESP=y
# CONFIG_INET6_IPCOMP is not set
CONFIG_IPV6_MIP6=y
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_BEET is not set
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=y
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
# CONFIG_IPV6_PIMSM_V2 is not set
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
CONFIG_IP_DCCP=y
CONFIG_INET_DCCP_DIAG=y

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
CONFIG_IP_DCCP_CCID2_DEBUG=y
# CONFIG_IP_DCCP_CCID3 is not set

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
CONFIG_IP_SCTP=y
CONFIG_SCTP_DBG_MSG=y
CONFIG_SCTP_DBG_OBJCNT=y
# CONFIG_SCTP_HMAC_NONE is not set
CONFIG_SCTP_HMAC_SHA1=y
# CONFIG_SCTP_HMAC_MD5 is not set
CONFIG_RDS=y
CONFIG_RDS_RDMA=y
CONFIG_RDS_TCP=y
# CONFIG_RDS_DEBUG is not set
CONFIG_TIPC=y
CONFIG_TIPC_ADVANCED=y
CONFIG_TIPC_ZONES=3
CONFIG_TIPC_CLUSTERS=1
CONFIG_TIPC_NODES=255
CONFIG_TIPC_PORTS=8191
CONFIG_TIPC_LOG=0
CONFIG_TIPC_DEBUG=y
# CONFIG_ATM is not set
CONFIG_L2TP=y
# CONFIG_L2TP_DEBUGFS is not set
CONFIG_L2TP_V3=y
# CONFIG_L2TP_IP is not set
# CONFIG_L2TP_ETH is not set
CONFIG_STP=y
CONFIG_GARP=y
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_DECNET=y
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
# CONFIG_LTPC is not set
# CONFIG_IPDDP is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
CONFIG_ECONET=y
# CONFIG_ECONET_AUNUDP is not set
# CONFIG_ECONET_NATIVE is not set
CONFIG_WAN_ROUTER=y
CONFIG_PHONET=y
CONFIG_IEEE802154=y
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
CONFIG_RPS=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
CONFIG_NET_DROP_MONITOR=y
# CONFIG_HAMRADIO is not set
CONFIG_CAN=y
CONFIG_CAN_RAW=y
CONFIG_CAN_BCM=y

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
# CONFIG_CAN_DEV is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_IRDA is not set
CONFIG_BT=y
# CONFIG_BT_L2CAP is not set
# CONFIG_BT_SCO is not set

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIBTUSB is not set
CONFIG_BT_HCIUART=y
# CONFIG_BT_HCIUART_H4 is not set
CONFIG_BT_HCIUART_BCSP=y
# CONFIG_BT_HCIUART_ATH3K is not set
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIBCM203X=y
# CONFIG_BT_HCIBPA10X is not set
CONFIG_BT_HCIBFUSB=y
CONFIG_BT_HCIDTL1=y
# CONFIG_BT_HCIBT3C is not set
CONFIG_BT_HCIBLUECARD=y
# CONFIG_BT_HCIBTUART is not set
CONFIG_BT_HCIVHCI=y
CONFIG_BT_MRVL=y
CONFIG_AF_RXRPC=y
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=y
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=y
# CONFIG_NL80211_TESTMODE is not set
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
# CONFIG_CFG80211_REG_DEBUG is not set
# CONFIG_CFG80211_DEFAULT_PS is not set
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=y
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
CONFIG_MAC80211_DEBUG_MENU=y
CONFIG_MAC80211_NOINLINE=y
CONFIG_MAC80211_VERBOSE_DEBUG=y
CONFIG_MAC80211_HT_DEBUG=y
# CONFIG_MAC80211_TKIP_DEBUG is not set
# CONFIG_MAC80211_IBSS_DEBUG is not set
CONFIG_MAC80211_VERBOSE_PS_DEBUG=y
CONFIG_MAC80211_DEBUG_COUNTERS=y
# CONFIG_MAC80211_DRIVER_API_TRACER is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
CONFIG_CAIF=y
CONFIG_CAIF_DEBUG=y
# CONFIG_CAIF_NETDEV is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_DEBUG_DRIVER=y
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
CONFIG_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_ISAPNP=y
# CONFIG_PNPBIOS is not set
# CONFIG_PNPACPI is not set
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
CONFIG_BLK_DEV_XD=y
CONFIG_BLK_CPQ_DA=y
CONFIG_BLK_CPQ_CISS_DA=y
CONFIG_CISS_SCSI_TAPE=y
# CONFIG_BLK_DEV_DAC960 is not set
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
CONFIG_BLK_DEV_DRBD=y
CONFIG_DRBD_FAULT_INJECTION=y
# CONFIG_BLK_DEV_NBD is not set
CONFIG_BLK_DEV_SX8=y
CONFIG_BLK_DEV_UB=y
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
CONFIG_ATA_OVER_ETH=y
# CONFIG_BLK_DEV_HD is not set
# CONFIG_MISC_DEVICES is not set
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_ATA=y
# CONFIG_SCSI_SAS_HOST_SMP is not set
CONFIG_SCSI_SAS_LIBSAS_DEBUG=y
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=y
# CONFIG_ISCSI_BOOT_SYSFS is not set
CONFIG_SCSI_BNX2_ISCSI=y
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
CONFIG_SCSI_3W_9XXX=y
# CONFIG_SCSI_3W_SAS is not set
CONFIG_SCSI_7000FASST=y
CONFIG_SCSI_ACARD=y
# CONFIG_SCSI_AHA152X is not set
# CONFIG_SCSI_AHA1740 is not set
CONFIG_SCSI_AACRAID=y
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
# CONFIG_AIC7XXX_DEBUG_ENABLE is not set
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC7XXX_OLD=y
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
CONFIG_SCSI_MVSAS=y
# CONFIG_SCSI_MVSAS_DEBUG is not set
CONFIG_SCSI_DPT_I2O=y
CONFIG_SCSI_ADVANSYS=y
CONFIG_SCSI_IN2000=y
CONFIG_SCSI_ARCMSR=y
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=y
# CONFIG_MEGARAID_MAILBOX is not set
# CONFIG_MEGARAID_LEGACY is not set
CONFIG_MEGARAID_SAS=y
CONFIG_SCSI_MPT2SAS=y
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
# CONFIG_SCSI_MPT2SAS_LOGGING is not set
CONFIG_SCSI_HPTIOP=y
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_VMWARE_PVSCSI is not set
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
CONFIG_FCOE=y
# CONFIG_FCOE_FNIC is not set
CONFIG_SCSI_DMX3191D=y
CONFIG_SCSI_DTC3280=y
CONFIG_SCSI_EATA=y
CONFIG_SCSI_EATA_TAGGED_QUEUE=y
CONFIG_SCSI_EATA_LINKED_COMMANDS=y
CONFIG_SCSI_EATA_MAX_TAGS=16
CONFIG_SCSI_FUTURE_DOMAIN=y
CONFIG_SCSI_FD_MCS=y
CONFIG_SCSI_GDTH=y
# CONFIG_SCSI_GENERIC_NCR5380 is not set
# CONFIG_SCSI_GENERIC_NCR5380_MMIO is not set
CONFIG_SCSI_IBMMCA=y
# CONFIG_IBMMCA_SCSI_ORDER_STANDARD is not set
CONFIG_IBMMCA_SCSI_DEV_RESET=y
CONFIG_SCSI_IPS=y
CONFIG_SCSI_INITIO=y
# CONFIG_SCSI_INIA100 is not set
CONFIG_SCSI_NCR53C406A=y
CONFIG_SCSI_NCR_D700=y
CONFIG_SCSI_STEX=y
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
CONFIG_SCSI_NCR_Q720=y
CONFIG_SCSI_NCR53C8XX_DEFAULT_TAGS=8
CONFIG_SCSI_NCR53C8XX_MAX_TAGS=32
CONFIG_SCSI_NCR53C8XX_SYNC=20
# CONFIG_SCSI_PAS16 is not set
# CONFIG_SCSI_QLOGIC_FAS is not set
CONFIG_SCSI_QLOGIC_1280=y
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
CONFIG_SCSI_LPFC=y
# CONFIG_SCSI_LPFC_DEBUG_FS is not set
CONFIG_SCSI_SIM710=y
# CONFIG_SCSI_SYM53C416 is not set
CONFIG_SCSI_DC395x=y
# CONFIG_SCSI_DC390T is not set
CONFIG_SCSI_T128=y
CONFIG_SCSI_U14_34F=y
# CONFIG_SCSI_U14_34F_TAGGED_QUEUE is not set
CONFIG_SCSI_U14_34F_LINKED_COMMANDS=y
CONFIG_SCSI_U14_34F_MAX_TAGS=8
CONFIG_SCSI_ULTRASTOR=y
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
CONFIG_SCSI_BFA_FC=y
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
# CONFIG_SCSI_DH is not set
CONFIG_SCSI_OSD_INITIATOR=y
# CONFIG_SCSI_OSD_ULD is not set
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
CONFIG_SATA_AHCI_PLATFORM=y
# CONFIG_SATA_INIC162X is not set
CONFIG_SATA_SIL24=y
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=y
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=y
CONFIG_SATA_MV=y
CONFIG_SATA_NV=y
CONFIG_SATA_PROMISE=y
# CONFIG_SATA_SIL is not set
CONFIG_SATA_SIS=y
CONFIG_SATA_SVW=y
CONFIG_SATA_ULI=y
CONFIG_SATA_VIA=y
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
CONFIG_PATA_ALI=y
CONFIG_PATA_AMD=y
CONFIG_PATA_ARTOP=y
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
CONFIG_PATA_CS5520=y
# CONFIG_PATA_CS5530 is not set
CONFIG_PATA_CS5535=y
CONFIG_PATA_CS5536=y
# CONFIG_PATA_CYPRESS is not set
CONFIG_PATA_EFAR=y
# CONFIG_PATA_HPT366 is not set
CONFIG_PATA_HPT37X=y
CONFIG_PATA_HPT3X2N=y
# CONFIG_PATA_HPT3X3 is not set
CONFIG_PATA_IT8213=y
CONFIG_PATA_IT821X=y
CONFIG_PATA_JMICRON=y
CONFIG_PATA_MARVELL=y
# CONFIG_PATA_NETCELL is not set
CONFIG_PATA_NINJA32=y
CONFIG_PATA_NS87415=y
CONFIG_PATA_OLDPIIX=y
CONFIG_PATA_OPTIDMA=y
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
CONFIG_PATA_RDC=y
# CONFIG_PATA_SC1200 is not set
CONFIG_PATA_SCH=y
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
CONFIG_PATA_SIS=y
CONFIG_PATA_TOSHIBA=y
# CONFIG_PATA_TRIFLEX is not set
CONFIG_PATA_VIA=y
CONFIG_PATA_WINBOND=y

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
CONFIG_PATA_ISAPNP=y
CONFIG_PATA_MPIIX=y
CONFIG_PATA_NS87410=y
# CONFIG_PATA_OPTI is not set
CONFIG_PATA_PCMCIA=y
CONFIG_PATA_QDI=y
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_WINBOND_VLB is not set

#
# Generic fallback / legacy drivers
#
CONFIG_ATA_GENERIC=y
CONFIG_PATA_LEGACY=y
# CONFIG_MD is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# You can enable one or both FireWire driver stacks.
#

#
# The newer stack is recommended.
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_OHCI_DEBUG=y
CONFIG_FIREWIRE_SBP2=y
CONFIG_FIREWIRE_NET=y
CONFIG_IEEE1394=y
CONFIG_IEEE1394_OHCI1394=y
CONFIG_IEEE1394_PCILYNX=y
CONFIG_IEEE1394_SBP2=y
# CONFIG_IEEE1394_SBP2_PHYS_DMA is not set
# CONFIG_IEEE1394_ETH1394_ROM_ENTRY is not set
# CONFIG_IEEE1394_ETH1394 is not set
CONFIG_IEEE1394_RAWIO=y
CONFIG_IEEE1394_VIDEO1394=y
# CONFIG_IEEE1394_DV1394 is not set
# CONFIG_IEEE1394_VERBOSEDEBUG is not set
CONFIG_FIREWIRE_NOSY=y
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_DUMMY=y
CONFIG_BONDING=y
CONFIG_MACVLAN=y
# CONFIG_MACVTAP is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
CONFIG_NET_SB1000=y
CONFIG_ARCNET=y
CONFIG_ARCNET_1201=y
CONFIG_ARCNET_1051=y
# CONFIG_ARCNET_RAW is not set
# CONFIG_ARCNET_CAP is not set
# CONFIG_ARCNET_COM90xx is not set
CONFIG_ARCNET_COM90xxIO=y
CONFIG_ARCNET_RIM_I=y
CONFIG_ARCNET_COM20020=y
# CONFIG_ARCNET_COM20020_ISA is not set
CONFIG_ARCNET_COM20020_PCI=y
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
# CONFIG_BROADCOM_PHY is not set
CONFIG_ICPLUS_PHY=y
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=y
# CONFIG_MICREL_PHY is not set
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
CONFIG_HAPPYMEAL=y
CONFIG_SUNGEM=y
# CONFIG_CASSINI is not set
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_VORTEX=y
# CONFIG_LANCE is not set
# CONFIG_NET_VENDOR_SMC is not set
# CONFIG_ETHOC is not set
# CONFIG_NET_VENDOR_RACAL is not set
CONFIG_DNET=y
# CONFIG_NET_TULIP is not set
# CONFIG_AT1700 is not set
# CONFIG_DEPCA is not set
# CONFIG_HP100 is not set
CONFIG_NET_ISA=y
CONFIG_E2100=y
CONFIG_EWRK3=y
CONFIG_EEXPRESS=y
CONFIG_EEXPRESS_PRO=y
CONFIG_HPLAN=y
CONFIG_LP486E=y
CONFIG_ETH16I=y
# CONFIG_NE2000 is not set
CONFIG_ZNET=y
# CONFIG_SEEQ8005 is not set
CONFIG_NE2_MCA=y
CONFIG_IBMLANA=y
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
CONFIG_PCNET32=y
CONFIG_AMD8111_ETH=y
CONFIG_ADAPTEC_STARFIRE=y
# CONFIG_AC3200 is not set
# CONFIG_KSZ884X_PCI is not set
CONFIG_APRICOT=y
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_FORCEDETH=y
# CONFIG_CS89x0 is not set
CONFIG_E100=y
CONFIG_LNE390=y
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
CONFIG_NE2K_PCI=y
# CONFIG_NE3210 is not set
# CONFIG_ES3210 is not set
# CONFIG_8139CP is not set
CONFIG_8139TOO=y
# CONFIG_8139TOO_PIO is not set
CONFIG_8139TOO_TUNE_TWISTER=y
# CONFIG_8139TOO_8129 is not set
CONFIG_8139_OLD_RX_RESET=y
CONFIG_R6040=y
CONFIG_SIS900=y
CONFIG_EPIC100=y
CONFIG_SMSC9420=y
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_KS8842 is not set
# CONFIG_KS8851_MLL is not set
# CONFIG_VIA_RHINE is not set
CONFIG_SC92031=y
# CONFIG_NET_POCKET is not set
# CONFIG_ATL2 is not set
CONFIG_NETDEV_1000=y
CONFIG_ACENIC=y
# CONFIG_ACENIC_OMIT_TIGON_I is not set
CONFIG_DL2K=y
# CONFIG_E1000 is not set
CONFIG_E1000E=y
CONFIG_IP1000=y
CONFIG_IGB=y
# CONFIG_IGB_DCA is not set
# CONFIG_IGBVF is not set
CONFIG_NS83820=y
CONFIG_HAMACHI=y
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
CONFIG_SKGE=y
CONFIG_SKGE_DEBUG=y
# CONFIG_SKY2 is not set
CONFIG_VIA_VELOCITY=y
CONFIG_TIGON3=y
CONFIG_BNX2=y
CONFIG_CNIC=y
CONFIG_QLA3XXX=y
# CONFIG_ATL1 is not set
CONFIG_ATL1E=y
CONFIG_ATL1C=y
CONFIG_JME=y
# CONFIG_NETDEV_10000 is not set
CONFIG_TR=y
# CONFIG_IBMTR is not set
# CONFIG_IBMOL is not set
CONFIG_IBMLS=y
# CONFIG_3C359 is not set
CONFIG_TMS380TR=y
CONFIG_TMSPCI=y
# CONFIG_SKISA is not set
# CONFIG_PROTEON is not set
CONFIG_ABYSS=y
# CONFIG_MADGEMC is not set
CONFIG_SMCTR=y
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
CONFIG_USB_RTL8150=y
CONFIG_USB_USBNET=y
# CONFIG_USB_NET_AX8817X is not set
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
CONFIG_USB_NET_DM9601=y
# CONFIG_USB_NET_SMSC75XX is not set
# CONFIG_USB_NET_SMSC95XX is not set
CONFIG_USB_NET_GL620A=y
CONFIG_USB_NET_NET1080=y
CONFIG_USB_NET_PLUSB=y
# CONFIG_USB_NET_MCS7830 is not set
# CONFIG_USB_NET_RNDIS_HOST is not set
CONFIG_USB_NET_CDC_SUBSET=y
# CONFIG_USB_ALI_M5632 is not set
CONFIG_USB_AN2720=y
# CONFIG_USB_BELKIN is not set
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
# CONFIG_USB_KC2190 is not set
CONFIG_USB_NET_ZAURUS=y
CONFIG_USB_NET_INT51X1=y
CONFIG_USB_CDC_PHONET=y
CONFIG_USB_IPHETH=y
CONFIG_USB_SIERRA_NET=y
CONFIG_NET_PCMCIA=y
# CONFIG_PCMCIA_3C589 is not set
# CONFIG_PCMCIA_3C574 is not set
# CONFIG_PCMCIA_FMVJ18X is not set
CONFIG_PCMCIA_PCNET=y
# CONFIG_PCMCIA_NMCLAN is not set
# CONFIG_PCMCIA_SMC91C92 is not set
CONFIG_PCMCIA_XIRC2PS=y
# CONFIG_PCMCIA_AXNET is not set
CONFIG_ARCNET_COM20020_CS=y
# CONFIG_PCMCIA_IBMTR is not set
CONFIG_WAN=y
# CONFIG_HDLC is not set
CONFIG_DLCI=y
CONFIG_DLCI_MAX=8
# CONFIG_SDLA is not set
CONFIG_WAN_ROUTER_DRIVERS=y
CONFIG_CYCLADES_SYNC=y
CONFIG_CYCLOMX_X25=y
# CONFIG_SBNI is not set
CONFIG_IEEE802154_DRIVERS=y
# CONFIG_IEEE802154_FAKEHARD is not set

#
# CAIF transport drivers
#
# CONFIG_CAIF_TTY is not set
CONFIG_CAIF_SPI_SLAVE=y
CONFIG_CAIF_SPI_SYNC=y
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PLIP is not set
CONFIG_PPP=y
CONFIG_PPP_MULTILINK=y
# CONFIG_PPP_FILTER is not set
# CONFIG_PPP_ASYNC is not set
CONFIG_PPP_SYNC_TTY=y
# CONFIG_PPP_DEFLATE is not set
# CONFIG_PPP_BSDCOMP is not set
# CONFIG_PPP_MPPE is not set
CONFIG_PPPOE=y
CONFIG_PPPOL2TP=y
# CONFIG_SLIP is not set
CONFIG_SLHC=y
CONFIG_NET_FC=y
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_VMXNET3 is not set
CONFIG_ISDN=y
# CONFIG_ISDN_I4L is not set
CONFIG_ISDN_CAPI=y
CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=y
CONFIG_CAPI_TRACE=y
CONFIG_ISDN_CAPI_MIDDLEWARE=y
CONFIG_ISDN_CAPI_CAPI20=y
CONFIG_ISDN_CAPI_CAPIFS_BOOL=y
CONFIG_ISDN_CAPI_CAPIFS=y

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
CONFIG_ISDN_DRV_AVMB1_B1ISA=y
CONFIG_ISDN_DRV_AVMB1_B1PCI=y
# CONFIG_ISDN_DRV_AVMB1_B1PCIV4 is not set
# CONFIG_ISDN_DRV_AVMB1_T1ISA is not set
# CONFIG_ISDN_DRV_AVMB1_B1PCMCIA is not set
# CONFIG_ISDN_DRV_AVMB1_T1PCI is not set
# CONFIG_ISDN_DRV_AVMB1_C4 is not set
CONFIG_CAPI_EICON=y
# CONFIG_ISDN_DIVAS is not set
# CONFIG_ISDN_DRV_GIGASET is not set
CONFIG_PHONE=y
CONFIG_PHONE_IXJ=y
CONFIG_PHONE_IXJ_PCMCIA=y

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5520=y
# CONFIG_KEYBOARD_ADP5588 is not set
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT2160=y
CONFIG_KEYBOARD_LKKBD=y
# CONFIG_KEYBOARD_GPIO is not set
CONFIG_KEYBOARD_TCA6416=y
CONFIG_KEYBOARD_MATRIX=y
CONFIG_KEYBOARD_LM8323=y
# CONFIG_KEYBOARD_MAX7359 is not set
CONFIG_KEYBOARD_MCS=y
# CONFIG_KEYBOARD_NEWTON is not set
CONFIG_KEYBOARD_OPENCORES=y
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_KEYBOARD_SUNKBD=y
CONFIG_KEYBOARD_XTKBD=y
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
# CONFIG_MOUSE_SERIAL is not set
CONFIG_MOUSE_APPLETOUCH=y
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_INPORT=y
# CONFIG_MOUSE_ATIXL is not set
# CONFIG_MOUSE_LOGIBM is not set
# CONFIG_MOUSE_PC110PAD is not set
CONFIG_MOUSE_VSXXXAA=y
# CONFIG_MOUSE_GPIO is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_GUNZE=y
# CONFIG_TOUCHSCREEN_ELO is not set
CONFIG_TOUCHSCREEN_WACOM_W8001=y
# CONFIG_TOUCHSCREEN_MCS5000 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
CONFIG_TOUCHSCREEN_INEXIO=y
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_HTCPEN is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
CONFIG_TOUCHSCREEN_QT602240=y
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
CONFIG_TOUCHSCREEN_TOUCHWIN=y
# CONFIG_TOUCHSCREEN_WM97XX is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=y
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_TPS6507X is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_AD714X=y
# CONFIG_INPUT_AD714X_I2C is not set
CONFIG_INPUT_PCSPKR=y
# CONFIG_INPUT_APANEL is not set
CONFIG_INPUT_WISTRON_BTNS=y
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
CONFIG_INPUT_KEYSPAN_REMOTE=y
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=y
# CONFIG_INPUT_WINBOND_CIR is not set
CONFIG_INPUT_PCF8574=y
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
# CONFIG_INPUT_ADXL34X is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
# CONFIG_DEVKMEM is not set
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_COMPUTONE=y
CONFIG_ROCKETPORT=y
CONFIG_CYCLADES=y
# CONFIG_CYZ_INTR is not set
CONFIG_DIGIEPCA=y
CONFIG_MOXA_INTELLIO=y
# CONFIG_MOXA_SMARTIO is not set
CONFIG_ISI=y
CONFIG_SYNCLINK=y
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_N_HDLC is not set
# CONFIG_N_GSM is not set
# CONFIG_RISCOM8 is not set
CONFIG_SPECIALIX=y
CONFIG_STALDRV=y
CONFIG_STALLION=y
# CONFIG_ISTALLION is not set
CONFIG_NOZOMI=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CS=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
CONFIG_SERIAL_8250_MCA=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
CONFIG_SERIAL_TIMBERDALE=y
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_PRINTER=y
CONFIG_LP_CONSOLE=y
# CONFIG_PPDEV is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
# CONFIG_DTLK is not set
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
CONFIG_SONYPI=y

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=y
CONFIG_CARDMAN_4000=y
CONFIG_CARDMAN_4040=y
# CONFIG_IPWIRELESS is not set
CONFIG_MWAVE=y
# CONFIG_SCx200_GPIO is not set
# CONFIG_PC8736x_GPIO is not set
CONFIG_NSC_GPIO=y
CONFIG_CS5535_GPIO=y
# CONFIG_RAW_DRIVER is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_NSC=y
# CONFIG_TCG_ATMEL is not set
CONFIG_TCG_INFINEON=y
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_RAMOOPS is not set
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
# CONFIG_I2C_ALI1563 is not set
CONFIG_I2C_ALI15X3=y
# CONFIG_I2C_AMD756 is not set
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=y
CONFIG_I2C_VIAPRO=y

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_GPIO is not set
CONFIG_I2C_OCORES=y
# CONFIG_I2C_PCA_PLATFORM is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=y

#
# Other I2C/SMBus bus drivers
#
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
CONFIG_I2C_DEBUG_BUS=y
# CONFIG_SPI is not set

#
# PPS support
#
# CONFIG_PPS is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO expanders:
#
# CONFIG_GPIO_IT8761E is not set
# CONFIG_GPIO_SCH is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_MAX7300=y
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_SX150X is not set
# CONFIG_GPIO_ADP5520 is not set
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
CONFIG_GPIO_BT8XX=y
# CONFIG_GPIO_LANGWELL is not set
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=y
CONFIG_W1_MASTER_DS2482=y
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=y
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
CONFIG_TEST_POWER=y
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_OLPC=y
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_MAX17040=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=y
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=y
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=y
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
CONFIG_SENSORS_K8TEMP=y
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_ASB100 is not set
CONFIG_SENSORS_ATXP1=y
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=y
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_PKGTEMP=y
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=y
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LM95241=y
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX6650=y
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=y
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SIS5595=y
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_EMC1403=y
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_AMC6821=y
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
# CONFIG_SENSORS_VIA_CPUTEMP is not set
CONFIG_SENSORS_VIA686A=y
# CONFIG_SENSORS_VT1211 is not set
CONFIG_SENSORS_VT8231=y
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83L785TS=y
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_LIS3_I2C is not set
CONFIG_SENSORS_APPLESMC=y
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
# CONFIG_SSB_PCMCIAHOST is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_MFD_SUPPORT=y
CONFIG_MFD_CORE=y
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_SM501 is not set
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
# CONFIG_UCB1400_CORE is not set
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_TC35892 is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_LPC_SCH=y
CONFIG_MFD_RDC321X=y
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_TPS6586X is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_DUMMY=y
# CONFIG_REGULATOR_FIXED_VOLTAGE is not set
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_BQ24022 is not set
# CONFIG_REGULATOR_MAX1586 is not set
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_LP3971=y
# CONFIG_REGULATOR_TPS65023 is not set
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_ISL6271A=y
# CONFIG_REGULATOR_AD5398 is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_COMMON=y
CONFIG_VIDEO_ALLOW_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_DVB_CORE=y
CONFIG_VIDEO_MEDIA=y

#
# Multimedia drivers
#
CONFIG_VIDEO_SAA7146=y
CONFIG_VIDEO_SAA7146_VV=y
CONFIG_IR_CORE=y
CONFIG_VIDEO_IR=y
CONFIG_LIRC=y
# CONFIG_RC_MAP is not set
CONFIG_IR_NEC_DECODER=y
# CONFIG_IR_RC5_DECODER is not set
# CONFIG_IR_RC6_DECODER is not set
# CONFIG_IR_JVC_DECODER is not set
# CONFIG_IR_SONY_DECODER is not set
CONFIG_IR_LIRC_CODEC=y
# CONFIG_IR_IMON is not set
# CONFIG_IR_MCEUSB is not set
CONFIG_IR_ENE=y
# CONFIG_IR_STREAMZAP is not set
CONFIG_MEDIA_TUNER=y
CONFIG_MEDIA_TUNER_CUSTOMISE=y
# CONFIG_MEDIA_TUNER_SIMPLE is not set
# CONFIG_MEDIA_TUNER_TDA8290 is not set
CONFIG_MEDIA_TUNER_TDA827X=y
# CONFIG_MEDIA_TUNER_TDA18271 is not set
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
CONFIG_MEDIA_TUNER_TEA5767=y
# CONFIG_MEDIA_TUNER_MT20XX is not set
CONFIG_MEDIA_TUNER_MT2060=y
CONFIG_MEDIA_TUNER_MT2266=y
# CONFIG_MEDIA_TUNER_MT2131 is not set
CONFIG_MEDIA_TUNER_QT1010=y
CONFIG_MEDIA_TUNER_XC2028=y
# CONFIG_MEDIA_TUNER_XC5000 is not set
# CONFIG_MEDIA_TUNER_MXL5005S is not set
# CONFIG_MEDIA_TUNER_MXL5007T is not set
# CONFIG_MEDIA_TUNER_MC44S803 is not set
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_V4L1=y
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_DMA_SG=y
# CONFIG_VIDEO_CAPTURE_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
CONFIG_RADIO_ADAPTERS=y
# CONFIG_RADIO_CADET is not set
CONFIG_RADIO_RTRACK2=y
CONFIG_RADIO_RTRACK2_PORT=30c
CONFIG_RADIO_AZTECH=y
CONFIG_RADIO_AZTECH_PORT=350
# CONFIG_RADIO_GEMTEK is not set
CONFIG_RADIO_GEMTEK_PCI=y
# CONFIG_RADIO_MAXIRADIO is not set
# CONFIG_RADIO_MAESTRO is not set
CONFIG_RADIO_MIROPCM20=y
# CONFIG_RADIO_SF16FMI is not set
# CONFIG_RADIO_SF16FMR2 is not set
# CONFIG_RADIO_TERRATEC is not set
# CONFIG_RADIO_TRUST is not set
# CONFIG_RADIO_TYPHOON is not set
CONFIG_RADIO_ZOLTRIX=y
CONFIG_RADIO_ZOLTRIX_PORT=20c
CONFIG_I2C_SI4713=y
# CONFIG_RADIO_SI4713 is not set
CONFIG_USB_DSBR=y
CONFIG_RADIO_SI470X=y
# CONFIG_USB_SI470X is not set
# CONFIG_I2C_SI470X is not set
# CONFIG_USB_MR800 is not set
# CONFIG_RADIO_TEA5764 is not set
# CONFIG_RADIO_SAA7706H is not set
CONFIG_RADIO_TEF6862=y
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y
CONFIG_DVB_CAPTURE_DRIVERS=y

#
# Supported SAA7146 based PCI Adapters
#
CONFIG_TTPCI_EEPROM=y
CONFIG_DVB_AV7110=y
CONFIG_DVB_AV7110_OSD=y
CONFIG_DVB_BUDGET_CORE=y
# CONFIG_DVB_BUDGET is not set
CONFIG_DVB_BUDGET_CI=y
CONFIG_DVB_BUDGET_AV=y
# CONFIG_DVB_BUDGET_PATCH is not set

#
# Supported USB Adapters
#
# CONFIG_DVB_USB is not set
# CONFIG_DVB_TTUSB_BUDGET is not set
# CONFIG_DVB_TTUSB_DEC is not set
CONFIG_SMS_SIANO_MDTV=y

#
# Siano module components
#
# CONFIG_SMS_USB_DRV is not set

#
# Supported FlexCopII (B2C2) Adapters
#
CONFIG_DVB_B2C2_FLEXCOP=y
# CONFIG_DVB_B2C2_FLEXCOP_PCI is not set
CONFIG_DVB_B2C2_FLEXCOP_USB=y
CONFIG_DVB_B2C2_FLEXCOP_DEBUG=y

#
# Supported BT878 Adapters
#

#
# Supported Pluto2 Adapters
#
# CONFIG_DVB_PLUTO2 is not set

#
# Supported SDMC DM1105 Adapters
#
CONFIG_DVB_DM1105=y

#
# Supported FireWire (IEEE 1394) Adapters
#
CONFIG_DVB_FIREDTV=y
CONFIG_DVB_FIREDTV_FIREWIRE=y
CONFIG_DVB_FIREDTV_IEEE1394=y
CONFIG_DVB_FIREDTV_INPUT=y

#
# Supported Earthsoft PT1 Adapters
#
# CONFIG_DVB_PT1 is not set

#
# Supported Mantis Adapters
#
# CONFIG_MANTIS_CORE is not set

#
# Supported nGene Adapters
#
CONFIG_DVB_NGENE=y

#
# Supported DVB Frontends
#
# CONFIG_DVB_FE_CUSTOMISE is not set
CONFIG_DVB_STB0899=y
CONFIG_DVB_STB6100=y
CONFIG_DVB_STV090x=y
CONFIG_DVB_STV6110x=y
CONFIG_DVB_CX24123=y
CONFIG_DVB_MT312=y
CONFIG_DVB_S5H1420=y
CONFIG_DVB_STV0288=y
CONFIG_DVB_STB6000=y
CONFIG_DVB_STV0299=y
CONFIG_DVB_TDA8083=y
CONFIG_DVB_TDA8261=y
CONFIG_DVB_VES1X93=y
CONFIG_DVB_TUNER_ITD1000=y
CONFIG_DVB_TUNER_CX24113=y
CONFIG_DVB_TUA6100=y
CONFIG_DVB_CX24116=y
CONFIG_DVB_SI21XX=y
CONFIG_DVB_DS3000=y
CONFIG_DVB_SP8870=y
CONFIG_DVB_L64781=y
CONFIG_DVB_TDA1004X=y
CONFIG_DVB_MT352=y
CONFIG_DVB_VES1820=y
CONFIG_DVB_TDA10021=y
CONFIG_DVB_TDA10023=y
CONFIG_DVB_STV0297=y
CONFIG_DVB_NXT200X=y
CONFIG_DVB_BCM3510=y
CONFIG_DVB_LGDT330X=y
CONFIG_DVB_PLL=y
CONFIG_DVB_LNBP21=y
CONFIG_DVB_ISL6421=y
CONFIG_DAB=y
# CONFIG_USB_DABUSB is not set

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_ALI is not set
CONFIG_AGP_ATI=y
CONFIG_AGP_AMD=y
# CONFIG_AGP_AMD64 is not set
# CONFIG_AGP_INTEL is not set
CONFIG_AGP_NVIDIA=y
# CONFIG_AGP_SIS is not set
CONFIG_AGP_SWORKS=y
CONFIG_AGP_VIA=y
CONFIG_AGP_EFFICEON=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_TTM=y
# CONFIG_DRM_TDFX is not set
CONFIG_DRM_R128=y
CONFIG_DRM_RADEON=y
CONFIG_DRM_MGA=y
# CONFIG_DRM_SIS is not set
CONFIG_DRM_VIA=y
CONFIG_DRM_SAVAGE=y
CONFIG_VGASTATE=y
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_PM2 is not set
CONFIG_FB_CYBER2000=y
# CONFIG_FB_ARC is not set
CONFIG_FB_IMSTT=y
CONFIG_FB_UVESA=y
CONFIG_FB_N411=y
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=y
CONFIG_FB_NVIDIA_I2C=y
# CONFIG_FB_NVIDIA_DEBUG is not set
# CONFIG_FB_NVIDIA_BACKLIGHT is not set
CONFIG_FB_RIVA=y
# CONFIG_FB_RIVA_I2C is not set
# CONFIG_FB_RIVA_DEBUG is not set
# CONFIG_FB_RIVA_BACKLIGHT is not set
# CONFIG_FB_LE80578 is not set
CONFIG_FB_MATROX=y
# CONFIG_FB_MATROX_MILLENIUM is not set
CONFIG_FB_MATROX_MYSTIQUE=y
# CONFIG_FB_MATROX_G is not set
CONFIG_FB_MATROX_I2C=y
CONFIG_FB_ATY128=y
# CONFIG_FB_ATY128_BACKLIGHT is not set
# CONFIG_FB_ATY is not set
CONFIG_FB_S3=y
CONFIG_FB_SAVAGE=y
# CONFIG_FB_SAVAGE_I2C is not set
CONFIG_FB_SAVAGE_ACCEL=y
CONFIG_FB_SIS=y
CONFIG_FB_SIS_300=y
CONFIG_FB_SIS_315=y
CONFIG_FB_VIA=y
CONFIG_FB_VIA_DIRECT_PROCFS=y
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
CONFIG_FB_VOODOO1=y
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=y
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
CONFIG_FB_CARMINE=y
# CONFIG_FB_CARMINE_DRAM_EVAL is not set
CONFIG_CARMINE_DRAM_CUSTOM=y
CONFIG_FB_GEODE=y
# CONFIG_FB_GEODE_LX is not set
CONFIG_FB_GEODE_GX=y
CONFIG_FB_GEODE_GX1=y
# CONFIG_FB_TMIO is not set
# CONFIG_FB_METRONOME is not set
CONFIG_FB_MB862XX=y
# CONFIG_FB_MB862XX_PCI_GDC is not set
CONFIG_FB_BROADSHEET=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_PROGEAR=y
CONFIG_BACKLIGHT_MBP_NVIDIA=y
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_ADP5520=y
# CONFIG_BACKLIGHT_ADP8860 is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
# CONFIG_LOGO is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_JACK=y
# CONFIG_SND_SEQUENCER is not set
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
# CONFIG_SND_HRTIMER is not set
# CONFIG_SND_DYNAMIC_MINORS is not set
# CONFIG_SND_SUPPORT_OLD_API is not set
# CONFIG_SND_VERBOSE_PROCFS is not set
CONFIG_SND_VERBOSE_PRINTK=y
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=y
CONFIG_SND_OPL3_LIB=y
CONFIG_SND_OPL4_LIB=y
CONFIG_SND_VX_LIB=y
CONFIG_SND_AC97_CODEC=y
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_WSS_LIB=y
CONFIG_SND_SB_COMMON=y
CONFIG_SND_SB16_DSP=y
CONFIG_SND_ISA=y
CONFIG_SND_ADLIB=y
# CONFIG_SND_AD1816A is not set
# CONFIG_SND_AD1848 is not set
CONFIG_SND_ALS100=y
CONFIG_SND_AZT2320=y
# CONFIG_SND_CMI8330 is not set
CONFIG_SND_CS4231=y
# CONFIG_SND_CS4236 is not set
# CONFIG_SND_ES1688 is not set
# CONFIG_SND_ES18XX is not set
# CONFIG_SND_SC6000 is not set
CONFIG_SND_GUSCLASSIC=y
CONFIG_SND_GUSEXTREME=y
# CONFIG_SND_GUSMAX is not set
# CONFIG_SND_INTERWAVE is not set
# CONFIG_SND_INTERWAVE_STB is not set
# CONFIG_SND_JAZZ16 is not set
CONFIG_SND_OPL3SA2=y
# CONFIG_SND_OPTI92X_AD1848 is not set
CONFIG_SND_OPTI92X_CS4231=y
CONFIG_SND_OPTI93X=y
CONFIG_SND_MIRO=y
# CONFIG_SND_SB8 is not set
CONFIG_SND_SB16=y
# CONFIG_SND_SBAWE is not set
CONFIG_SND_SB16_CSP=y
# CONFIG_SND_SGALAXY is not set
CONFIG_SND_SSCAPE=y
CONFIG_SND_WAVEFRONT=y
# CONFIG_SND_MSND_PINNACLE is not set
CONFIG_SND_MSND_CLASSIC=y
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=y
# CONFIG_SND_ALS300 is not set
CONFIG_SND_ALS4000=y
# CONFIG_SND_ALI5451 is not set
CONFIG_SND_ASIHPI=y
CONFIG_SND_ATIIXP=y
# CONFIG_SND_ATIIXP_MODEM is not set
CONFIG_SND_AU8810=y
CONFIG_SND_AU8820=y
CONFIG_SND_AU8830=y
# CONFIG_SND_AW2 is not set
CONFIG_SND_AZT3328=y
CONFIG_SND_BT87X=y
CONFIG_SND_BT87X_OVERCLOCK=y
CONFIG_SND_CA0106=y
# CONFIG_SND_CMIPCI is not set
CONFIG_SND_OXYGEN_LIB=y
CONFIG_SND_OXYGEN=y
CONFIG_SND_CS4281=y
CONFIG_SND_CS46XX=y
CONFIG_SND_CS46XX_NEW_DSP=y
# CONFIG_SND_CS5530 is not set
CONFIG_SND_CS5535AUDIO=y
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
CONFIG_SND_GINA20=y
CONFIG_SND_LAYLA20=y
CONFIG_SND_DARLA24=y
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
CONFIG_SND_MONA=y
CONFIG_SND_MIA=y
# CONFIG_SND_ECHO3G is not set
CONFIG_SND_INDIGO=y
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
CONFIG_SND_INDIGOIOX=y
CONFIG_SND_INDIGODJX=y
CONFIG_SND_EMU10K1=y
CONFIG_SND_EMU10K1X=y
CONFIG_SND_ENS1370=y
CONFIG_SND_ENS1371=y
CONFIG_SND_ES1938=y
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
CONFIG_SND_ICE1724=y
CONFIG_SND_INTEL8X0=y
CONFIG_SND_INTEL8X0M=y
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
CONFIG_SND_MIXART=y
# CONFIG_SND_NM256 is not set
CONFIG_SND_PCXHR=y
# CONFIG_SND_RIPTIDE is not set
CONFIG_SND_RME32=y
# CONFIG_SND_RME96 is not set
CONFIG_SND_RME9652=y
# CONFIG_SND_SIS7019 is not set
CONFIG_SND_SONICVIBES=y
CONFIG_SND_TRIDENT=y
# CONFIG_SND_VIA82XX is not set
CONFIG_SND_VIA82XX_MODEM=y
CONFIG_SND_VIRTUOSO=y
# CONFIG_SND_VX222 is not set
CONFIG_SND_YMFPCI=y
# CONFIG_SND_USB is not set
CONFIG_SND_PCMCIA=y
CONFIG_SND_VXPOCKET=y
# CONFIG_SND_PDAUDIOCF is not set
CONFIG_SND_SOC=y
CONFIG_SND_SOC_I2C_AND_SPI=y
# CONFIG_SND_SOC_ALL_CODECS is not set
CONFIG_SOUND_PRIME=y
# CONFIG_SOUND_OSS is not set
CONFIG_AC97_BUS=y
# CONFIG_HID_SUPPORT is not set
CONFIG_USB_MOUSE=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
CONFIG_USB_DEBUG=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
CONFIG_USB_DYNAMIC_MINORS=y
# CONFIG_USB_MON is not set
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_USB_OXU210HP_HCD=y
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_ISP1760_HCD=y
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_SSB=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_U132_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
# CONFIG_USB_STORAGE is not set
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
CONFIG_USB_USS720=y
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=y
# CONFIG_USB_SEVSEG is not set
CONFIG_USB_RIO500=y
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=y
CONFIG_USB_LED=y
CONFIG_USB_CYPRESS_CY7C63=y
CONFIG_USB_CYTHERM=y
# CONFIG_USB_IDMOUSE is not set
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=y
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=y
CONFIG_USB_TEST=y
CONFIG_USB_ISIGHTFW=y
CONFIG_USB_GADGET=y
CONFIG_USB_GADGET_DEBUG=y
CONFIG_USB_GADGET_DEBUG_FILES=y
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_SELECTED=y
CONFIG_USB_GADGET_R8A66597=y
CONFIG_USB_R8A66597=y
# CONFIG_USB_GADGET_M66592 is not set
# CONFIG_USB_GADGET_AMD5536UDC is not set
# CONFIG_USB_GADGET_CI13XXX is not set
# CONFIG_USB_GADGET_NET2280 is not set
# CONFIG_USB_GADGET_GOKU is not set
# CONFIG_USB_GADGET_LANGWELL is not set
# CONFIG_USB_GADGET_DUMMY_HCD is not set
CONFIG_USB_GADGET_DUALSPEED=y
# CONFIG_USB_ZERO is not set
# CONFIG_USB_AUDIO is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_FILE_STORAGE is not set
# CONFIG_USB_MASS_STORAGE is not set
CONFIG_USB_G_SERIAL=y
# CONFIG_USB_MIDI_GADGET is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_NOKIA is not set
# CONFIG_USB_G_MULTI is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
# CONFIG_USB_G_WEBCAM is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
CONFIG_USB_GPIO_VBUS=y
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_PCA9532=y
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_GPIO_PLATFORM=y
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_CLEVO_MAIL=y
CONFIG_LEDS_PCA955X=y
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_ADP5520=y
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGER_TIMER is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
CONFIG_LEDS_TRIGGER_GPIO=y
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=y
CONFIG_INFINIBAND_USER_MAD=y
# CONFIG_INFINIBAND_USER_ACCESS is not set
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=y
CONFIG_INFINIBAND_MTHCA_DEBUG=y
# CONFIG_INFINIBAND_AMSO1100 is not set
# CONFIG_MLX4_INFINIBAND is not set
CONFIG_INFINIBAND_NES=y
# CONFIG_INFINIBAND_NES_DEBUG is not set
CONFIG_INFINIBAND_IPOIB=y
CONFIG_INFINIBAND_IPOIB_CM=y
CONFIG_INFINIBAND_IPOIB_DEBUG=y
# CONFIG_INFINIBAND_IPOIB_DEBUG_DATA is not set
CONFIG_INFINIBAND_SRP=y
# CONFIG_INFINIBAND_ISER is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
# CONFIG_RTC_INTF_DEV is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=y
CONFIG_RTC_DRV_DS1374=y
CONFIG_RTC_DRV_DS1672=y
# CONFIG_RTC_DRV_DS3232 is not set
CONFIG_RTC_DRV_MAX6900=y
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
CONFIG_RTC_DRV_X1205=y
# CONFIG_RTC_DRV_PCF8563 is not set
CONFIG_RTC_DRV_PCF8583=y
# CONFIG_RTC_DRV_M41T80 is not set
CONFIG_RTC_DRV_BQ32K=y
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
CONFIG_RTC_DRV_RX8581=y
CONFIG_RTC_DRV_RX8025=y

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=y
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
CONFIG_RTC_DRV_DS1742=y
# CONFIG_RTC_DRV_STK17TA8 is not set
CONFIG_RTC_DRV_M48T86=y
CONFIG_RTC_DRV_M48T35=y
# CONFIG_RTC_DRV_M48T59 is not set
CONFIG_RTC_DRV_MSM6242=y
CONFIG_RTC_DRV_BQ4802=y
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=y

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH=y
CONFIG_INTEL_IOATDMA=y
CONFIG_TIMB_DMA=y
CONFIG_PCH_DMA=y
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set
CONFIG_DCA=y
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV is not set
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_AEC=y
CONFIG_UIO_SERCOS3=y
CONFIG_UIO_PCI_GENERIC=y
CONFIG_UIO_NETX=y
CONFIG_X86_PLATFORM_DEVICES=y

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
# CONFIG_EXT2_FS_POSIX_ACL is not set
# CONFIG_EXT2_FS_SECURITY is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
CONFIG_JFS_STATISTICS=y
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_NILFS2_FS is not set
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_OSF_PARTITION=y
# CONFIG_AMIGA_PARTITION is not set
CONFIG_ATARI_PARTITION=y
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
# CONFIG_UNIXWARE_DISKLABEL is not set
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
CONFIG_ULTRIX_PARTITION=y
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
CONFIG_SYSV68_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=y
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=y
CONFIG_DLM=y
# CONFIG_DLM_DEBUG is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
CONFIG_STRIP_ASM_SYMS=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
CONFIG_DETECT_HUNG_TASK=y
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
# CONFIG_SCHED_DEBUG is not set
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
# CONFIG_DEBUG_OBJECTS_FREE is not set
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_SLUB_DEBUG_ON is not set
CONFIG_SLUB_STATS=y
CONFIG_DEBUG_PREEMPT=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
CONFIG_DEBUG_HIGHMEM=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_BOOT_PRINTK_DELAY=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_DETECTOR=y
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_RCU_CPU_STALL_DETECTOR_RUNNABLE is not set
CONFIG_RCU_CPU_STALL_VERBOSE=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_LKDTM=y
CONFIG_CPU_NOTIFIER_ERROR_INJECT=y
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_PREEMPT_TRACER=y
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_BRANCH_PROFILE_NONE=y
CONFIG_STACK_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
# CONFIG_DYNAMIC_FTRACE is not set
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
CONFIG_EVENT_TRACE_TEST_SYSCALLS=y
CONFIG_MMIOTRACE=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
CONFIG_BUILD_DOCSRC=y
# CONFIG_DYNAMIC_DEBUG is not set
CONFIG_DMA_API_DEBUG=y
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_SAMPLES=y
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_KGDB=y
# CONFIG_KGDB_SERIAL_CONSOLE is not set
CONFIG_KGDB_TESTS=y
CONFIG_KGDB_LOW_LEVEL_TRAP=y
# CONFIG_KGDB_KDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_DOUBLEFAULT=y
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
CONFIG_IO_DELAY_UDELAY=y
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=2
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_NETWORK_XFRM is not set
# CONFIG_SECURITY_PATH is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_AUDIT=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA=y
CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=y

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA256 is not set
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_586 is not set
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_586=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_NLATTR=y
CONFIG_LRU_CACHE=y
CONFIG_FORCE_SUCCESSFUL_BUILD=y
CONFIG_FORCE_MINIMAL_CONFIG=y
CONFIG_FORCE_MINIMAL_CONFIG_PHYS=y
CONFIG_X86_32_ALWAYS_ON=y

--bg08WKrSYDhXBjb5--
