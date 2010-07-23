Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab0GWMpL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 08:45:11 -0400
Received: from p01c12o147.mxlogic.net ([208.65.145.70]:42884 "EHLO
	p01c12o147.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab0GWMpI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 08:45:08 -0400
X-Greylist: delayed 502 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Jul 2010 08:45:08 EDT
X-MXL-Hash: 4c498ed465e07bd1-1d0c5d08dcec90700e35fd58303f8da86b712847
X-MXL-Hash: 4c498cdd50a458ab-551f248bb907ee110c1418bd746dc8997e495f56
From: Andy Chittenden <andyc@bluearc.com>
To: "Linux Kernel Mailing List (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>
Date: Fri, 23 Jul 2010 13:36:41 +0100
Subject: RE: nfs client hang
Thread-Topic: nfs client hang
Thread-Index: AcspmBJWFkc0Kk81ShScwTGIcgxdigAyzY1g
Message-ID: <ABFC24E4C13D81489F7F624E14891C860310E110D7@uk-ex-mbx1.terastack.bluearc.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, en-GB
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010070601)]
X-MAIL-FROM: <andyc@bluearc.com>
X-SOURCE-IP: [213.121.168.131]
X-AnalysisOut: [v=1.0 c=1 a=VphdPIyG4kEA:10 a=kj9zAlcOel0A:10 a=sIqM7rbIUs]
X-AnalysisOut: [2FIam8obyq6w==:17 a=VwQbUJbxAAAA:8 a=xNf9USuDAAAA:8 a=E5qr]
X-AnalysisOut: [9jTlAAAA:8 a=ggBYX-qPLr0wyHaXXIEA:9 a=UyVKcg6p0VuEPAUgQ78A]
X-AnalysisOut: [:7 a=MpX4QO-8jj_HzktCNS_qskb_R4YA:4 a=CjuIK1q_8ugA:10 a=Cq]
X-AnalysisOut: [goUNhENt8A:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> IE the client starts a connection and then closes it again without sending data.

Once this happens, here's some rpcdebug info for the rpc module using 2.6.34.1 kernel:

... lots of the following nfsv3 WRITE requests:
[ 7670.026741] 57793 0001    -11 ffff88012e32b000   (null)        0 ffffffffa03beb10 nfsv3 WRITE a:call_reserveresult q:xprt_backlog
[ 7670.026759] 57794 0001    -11 ffff88012e32b000   (null)        0 ffffffffa03beb10 nfsv3 WRITE a:call_reserveresult q:xprt_backlog
[ 7670.026778] 57795 0001    -11 ffff88012e32b000   (null)        0 ffffffffa03beb10 nfsv3 WRITE a:call_reserveresult q:xprt_backlog
[ 7670.026797] 57796 0001    -11 ffff88012e32b000   (null)        0 ffffffffa03beb10 nfsv3 WRITE a:call_reserveresult q:xprt_backlog
[ 7670.026815] 57797 0001    -11 ffff88012e32b000   (null)        0 ffffffffa03beb10 nfsv3 WRITE a:call_reserveresult q:xprt_backlog
[ 7670.026834] 57798 0001    -11 ffff88012e32b000   (null)        0 ffffffffa03beb10 nfsv3 WRITE a:call_reserveresult q:xprt_backlog
[ 7670.026853] 57799 0001    -11 ffff88012e32b000   (null)        0 ffffffffa03beb10 nfsv3 WRITE a:call_reserveresult q:xprt_backlog
[ 7670.026871] 57800 0001    -11 ffff88012e32b000   (null)        0 ffffffffa03beb10 nfsv3 WRITE a:call_reserveresult q:xprt_backlog
[ 7670.026890] 57801 0001    -11 ffff88012e32b000   (null)        0 ffffffffa03beb10 nfsv3 WRITE a:call_reserveresult q:xprt_backlog
[ 7670.026909] 57802 0001    -11 ffff88012e32b000   (null)        0 ffffffffa03beb10 nfsv3 WRITE a:call_reserveresult q:xprt_backlog
[ 7680.520042] RPC:       worker connecting xprt ffff88013e62d800 via tcp to 10.1.6.102 (port 2049)
[ 7680.520066] RPC:       ffff88013e62d800 connect status 99 connected 0 sock state 7
[ 7680.520074] RPC: 33550 __rpc_wake_up_task (now 4296812426)
[ 7680.520079] RPC: 33550 disabling timer
[ 7680.520084] RPC: 33550 removed from queue ffff88013e62db20 "xprt_pending"
[ 7680.520089] RPC:       __rpc_wake_up_task done
[ 7680.520094] RPC: 33550 __rpc_execute flags=0x1
[ 7680.520098] RPC: 33550 xprt_connect_status: retrying
[ 7680.520103] RPC: 33550 call_connect_status (status -11)
[ 7680.520108] RPC: 33550 call_transmit (status 0)
[ 7680.520112] RPC: 33550 xprt_prepare_transmit
[ 7680.520118] RPC: 33550 rpc_xdr_encode (status 0)
[ 7680.520123] RPC: 33550 marshaling UNIX cred ffff88012e002300
[ 7680.520130] RPC: 33550 using AUTH_UNIX cred ffff88012e002300 to wrap rpc data
[ 7680.520136] RPC: 33550 xprt_transmit(32920)
[ 7680.520145] RPC:       xs_tcp_send_request(32920) = -32
[ 7680.520151] RPC:       xs_tcp_state_change client ffff88013e62d800...
[ 7680.520156] RPC:       state 7 conn 0 dead 0 zapped 1
[ 7680.520160] RPC:       disconnected transport ffff88013e62d800
[ 7680.520166] RPC: 33550 call_status (status -32)
[ 7680.520171] RPC: 33550 call_bind (status 0)
[ 7680.520175] RPC: 33550 call_connect xprt ffff88013e62d800 is not connected
[ 7680.520181] RPC: 33550 xprt_connect xprt ffff88013e62d800 is not connected
[ 7680.520187] RPC: 33550 sleep_on(queue "xprt_pending" time 4296812426)
[ 7680.520193] RPC: 33550 added to queue ffff88013e62db20 "xprt_pending"
[ 7680.520198] RPC: 33550 setting alarm for 60000 ms
[ 7680.520203] RPC:       xs_connect delayed xprt ffff88013e62d800 for 48 seconds
[ 7728.520042] RPC:       worker connecting xprt ffff88013e62d800 via tcp to 10.1.6.102 (port 2049)
[ 7728.520093] RPC:       ffff88013e62d800 connect status 115 connected 0 sock state 2
[ 7728.520884] RPC:       xs_tcp_state_change client ffff88013e62d800...
[ 7728.520889] RPC:       state 1 conn 0 dead 0 zapped 1
[ 7728.520896] RPC: 33550 __rpc_wake_up_task (now 4296824426)
[ 7728.520900] RPC: 33550 disabling timer
[ 7728.520906] RPC: 33550 removed from queue ffff88013e62db20 "xprt_pending"
[ 7728.520912] RPC:       __rpc_wake_up_task done
[ 7728.520932] RPC: 33550 __rpc_execute flags=0x1
[ 7728.520937] RPC: 33550 xprt_connect_status: retrying
[ 7728.520942] RPC: 33550 call_connect_status (status -11)
[ 7728.520947] RPC: 33550 call_transmit (status 0)
[ 7728.520951] RPC: 33550 xprt_prepare_transmit
[ 7728.520957] RPC: 33550 rpc_xdr_encode (status 0)
[ 7728.520962] RPC: 33550 marshaling UNIX cred ffff88012e002300
[ 7728.520969] RPC: 33550 using AUTH_UNIX cred ffff88012e002300 to wrap rpc data
[ 7728.520976] RPC: 33550 xprt_transmit(32920)
[ 7728.520984] RPC:       xs_tcp_send_request(32920) = -32
[ 7728.520997] RPC:       xs_tcp_state_change client ffff88013e62d800...
[ 7728.521007] RPC:       state 4 conn 1 dead 0 zapped 1
[ 7728.521013] RPC: 33550 call_status (status -32)
[ 7728.521018] RPC: 33550 call_bind (status 0)
[ 7728.521023] RPC: 33550 call_connect xprt ffff88013e62d800 is not connected
[ 7728.521028] RPC: 33550 xprt_connect xprt ffff88013e62d800 is not connected
[ 7728.521035] RPC: 33550 sleep_on(queue "xprt_pending" time 4296824426)
[ 7728.521040] RPC: 33550 added to queue ffff88013e62db20 "xprt_pending"
[ 7728.521045] RPC: 33550 setting alarm for 60000 ms
[ 7728.521439] RPC:       xs_tcp_state_change client ffff88013e62d800...
[ 7728.521444] RPC:       state 5 conn 0 dead 0 zapped 1
[ 7728.521602] RPC:       xs_tcp_state_change client ffff88013e62d800...
[ 7728.521608] RPC:       state 7 conn 0 dead 0 zapped 1
[ 7728.521612] RPC:       disconnected transport ffff88013e62d800
[ 7728.521617] RPC: 33550 __rpc_wake_up_task (now 4296824426)
[ 7728.521621] RPC: 33550 disabling timer
[ 7728.521626] RPC: 33550 removed from queue ffff88013e62db20 "xprt_pending"
[ 7728.521631] RPC:       __rpc_wake_up_task done
[ 7728.521636] RPC:       xs_tcp_state_change client ffff88013e62d800...
[ 7728.521641] RPC:       state 7 conn 0 dead 0 zapped 1
[ 7728.521645] RPC:       disconnected transport ffff88013e62d800
[ 7728.521649] RPC:       xs_tcp_data_ready...
[ 7728.521662] RPC: 33550 __rpc_execute flags=0x1
[ 7728.521666] RPC: 33550 xprt_connect_status: retrying
[ 7728.521671] RPC: 33550 call_connect_status (status -11)
[ 7728.521675] RPC: 33550 call_transmit (status 0)
[ 7728.521679] RPC: 33550 xprt_prepare_transmit
[ 7728.521683] RPC: 33550 rpc_xdr_encode (status 0)
[ 7728.521688] RPC: 33550 marshaling UNIX cred ffff88012e002300
[ 7728.521694] RPC: 33550 using AUTH_UNIX cred ffff88012e002300 to wrap rpc data
[ 7728.521699] RPC: 33550 xprt_transmit(32920)
[ 7728.521704] RPC:       xs_tcp_send_request(32920) = -32
[ 7728.521709] RPC:       xs_tcp_state_change client ffff88013e62d800...
[ 7728.521714] RPC:       state 7 conn 0 dead 0 zapped 1
[ 7728.521718] RPC:       disconnected transport ffff88013e62d800
[ 7728.521723] RPC: 33550 call_status (status -32)
[ 7728.521727] RPC: 33550 call_bind (status 0)
[ 7728.521732] RPC: 33550 call_connect xprt ffff88013e62d800 is not connected
[ 7728.521737] RPC: 33550 xprt_connect xprt ffff88013e62d800 is not connected
[ 7728.521743] RPC: 33550 sleep_on(queue "xprt_pending" time 4296824426)
[ 7728.521748] RPC: 33550 added to queue ffff88013e62db20 "xprt_pending"
[ 7728.521753] RPC: 33550 setting alarm for 60000 ms
[ 7728.521758] RPC:       xs_connect delayed xprt ffff88013e62d800 for 0 seconds
[ 7728.521763] RPC:       disconnecting xprt ffff88013e62d800 to reuse port
[ 7728.521771] RPC:       xs_error_report client ffff88013e62d800...
[ 7728.521773] RPC:       error 0
[ 7728.521778] RPC: 33550 __rpc_wake_up_task (now 4296824426)
[ 7728.521782] RPC: 33550 disabling timer
[ 7728.521786] RPC: 33550 removed from queue ffff88013e62db20 "xprt_pending"
[ 7728.521790] RPC:       __rpc_wake_up_task done
[ 7728.521794] RPC:       disconnected transport ffff88013e62d800
[ 7728.521800] RPC:       worker connecting xprt ffff88013e62d800 via tcp to 10.1.6.102 (port 2049)
[ 7728.521809] RPC:       ffff88013e62d800 connect status 99 connected 0 sock state 7
[ 7728.521815] RPC: 33550 __rpc_execute flags=0x1
[ 7728.521819] RPC: 33550 xprt_connect_status: retrying
[ 7728.521823] RPC: 33550 call_connect_status (status -11)
[ 7728.521828] RPC: 33550 call_transmit (status 0)
[ 7728.521831] RPC: 33550 xprt_prepare_transmit
[ 7728.521835] RPC: 33550 rpc_xdr_encode (status 0)
[ 7728.521840] RPC: 33550 marshaling UNIX cred ffff88012e002300
[ 7728.521845] RPC: 33550 using AUTH_UNIX cred ffff88012e002300 to wrap rpc data
[ 7728.521850] RPC: 33550 xprt_transmit(32920)
[ 7728.521855] RPC:       xs_tcp_send_request(32920) = -32
[ 7728.521859] RPC:       xs_tcp_state_change client ffff88013e62d800...
[ 7728.521864] RPC:       state 7 conn 0 dead 0 zapped 1
[ 7728.521868] RPC:       disconnected transport ffff88013e62d800
[ 7728.521873] RPC: 33550 call_status (status -32)
[ 7728.521877] RPC: 33550 call_bind (status 0)
[ 7728.521882] RPC: 33550 call_connect xprt ffff88013e62d800 is not connected
[ 7728.521887] RPC: 33550 xprt_connect xprt ffff88013e62d800 is not connected
[ 7728.521893] RPC: 33550 sleep_on(queue "xprt_pending" time 4296824426)
[ 7728.521898] RPC: 33550 added to queue ffff88013e62db20 "xprt_pending"
[ 7728.521902] RPC: 33550 setting alarm for 60000 ms
[ 7728.521907] RPC:       xs_connect delayed xprt ffff88013e62d800 for 3 seconds
[ 7731.520043] RPC:       worker connecting xprt ffff88013e62d800 via tcp to 10.1.6.102 (port 2049)
[ 7731.520063] RPC:       ffff88013e62d800 connect status 99 connected 0 sock state 7
[ 7731.520069] RPC: 33550 __rpc_wake_up_task (now 4296825176)
[ 7731.520073] RPC: 33550 disabling timer
[ 7731.520078] RPC: 33550 removed from queue ffff88013e62db20 "xprt_pending"
[ 7731.520082] RPC:       __rpc_wake_up_task done
[ 7731.520087] RPC: 33550 __rpc_execute flags=0x1
[ 7731.520092] RPC: 33550 xprt_connect_status: retrying
[ 7731.520096] RPC: 33550 call_connect_status (status -11)
[ 7731.520101] RPC: 33550 call_transmit (status 0)
[ 7731.520105] RPC: 33550 xprt_prepare_transmit
[ 7731.520110] RPC: 33550 rpc_xdr_encode (status 0)
[ 7731.520115] RPC: 33550 marshaling UNIX cred ffff88012e002300
[ 7731.520120] RPC: 33550 using AUTH_UNIX cred ffff88012e002300 to wrap rpc data
[ 7731.520126] RPC: 33550 xprt_transmit(32920)
[ 7731.520132] RPC:       xs_tcp_send_request(32920) = -32
[ 7731.520137] RPC:       xs_tcp_state_change client ffff88013e62d800...
[ 7731.520142] RPC:       state 7 conn 0 dead 0 zapped 1
[ 7731.520146] RPC:       disconnected transport ffff88013e62d800
[ 7731.520152] RPC: 33550 call_status (status -32)
[ 7731.520156] RPC: 33550 call_bind (status 0)
[ 7731.520161] RPC: 33550 call_connect xprt ffff88013e62d800 is not connected
[ 7731.520167] RPC: 33550 xprt_connect xprt ffff88013e62d800 is not connected
[ 7731.520172] RPC: 33550 sleep_on(queue "xprt_pending" time 4296825176)
[ 7731.520178] RPC: 33550 added to queue ffff88013e62db20 "xprt_pending"
[ 7731.520182] RPC: 33550 setting alarm for 60000 ms
[ 7731.520187] RPC:       xs_connect delayed xprt ffff88013e62d800 for 6 seconds
[ 7737.520042] RPC:       worker connecting xprt ffff88013e62d800 via tcp to 10.1.6.102 (port 2049)
[ 7737.520063] RPC:       ffff88013e62d800 connect status 99 connected 0 sock state 7
[ 7737.520070] RPC: 33550 __rpc_wake_up_task (now 4296826676)
[ 7737.520075] RPC: 33550 disabling timer
[ 7737.520080] RPC: 33550 removed from queue ffff88013e62db20 "xprt_pending"
[ 7737.520085] RPC:       __rpc_wake_up_task done
[ 7737.520089] RPC: 33550 __rpc_execute flags=0x1
[ 7737.520094] RPC: 33550 xprt_connect_status: retrying
[ 7737.520099] RPC: 33550 call_connect_status (status -11)
[ 7737.520104] RPC: 33550 call_transmit (status 0)
[ 7737.520108] RPC: 33550 xprt_prepare_transmit
[ 7737.520113] RPC: 33550 rpc_xdr_encode (status 0)
[ 7737.520118] RPC: 33550 marshaling UNIX cred ffff88012e002300
[ 7737.520125] RPC: 33550 using AUTH_UNIX cred ffff88012e002300 to wrap rpc data
[ 7737.520131] RPC: 33550 xprt_transmit(32920)
[ 7737.520139] RPC:       xs_tcp_send_request(32920) = -32
[ 7737.520144] RPC:       xs_tcp_state_change client ffff88013e62d800...
[ 7737.520149] RPC:       state 7 conn 0 dead 0 zapped 1
[ 7737.520154] RPC:       disconnected transport ffff88013e62d800
[ 7737.520159] RPC: 33550 call_status (status -32)
[ 7737.520164] RPC: 33550 call_bind (status 0)
[ 7737.520169] RPC: 33550 call_connect xprt ffff88013e62d800 is not connected
[ 7737.520175] RPC: 33550 xprt_connect xprt ffff88013e62d800 is not connected
[ 7737.520181] RPC: 33550 sleep_on(queue "xprt_pending" time 4296826676)
[ 7737.520187] RPC: 33550 added to queue ffff88013e62db20 "xprt_pending"
[ 7737.520191] RPC: 33550 setting alarm for 60000 ms
[ 7737.520197] RPC:       xs_connect delayed xprt ffff88013e62d800 for 12 seconds
[ 7749.520034] RPC:       worker connecting xprt ffff88013e62d800 via tcp to 10.1.6.102 (port 2049)
[ 7749.520056] RPC:       ffff88013e62d800 connect status 99 connected 0 sock state 7
[ 7749.520064] RPC: 33550 __rpc_wake_up_task (now 4296829676)
[ 7749.520069] RPC: 33550 disabling timer
[ 7749.520074] RPC: 33550 removed from queue ffff88013e62db20 "xprt_pending"
[ 7749.520079] RPC:       __rpc_wake_up_task done
[ 7749.520084] RPC: 33550 __rpc_execute flags=0x1
[ 7749.520088] RPC: 33550 xprt_connect_status: retrying
[ 7749.520093] RPC: 33550 call_connect_status (status -11)
[ 7749.520098] RPC: 33550 call_transmit (status 0)
[ 7749.520102] RPC: 33550 xprt_prepare_transmit
[ 7749.520107] RPC: 33550 rpc_xdr_encode (status 0)
[ 7749.520113] RPC: 33550 marshaling UNIX cred ffff88012e002300
[ 7749.520119] RPC: 33550 using AUTH_UNIX cred ffff88012e002300 to wrap rpc data
[ 7749.520126] RPC: 33550 xprt_transmit(32920)
[ 7749.520134] RPC:       xs_tcp_send_request(32920) = -32
[ 7749.520140] RPC:       xs_tcp_state_change client ffff88013e62d800...
[ 7749.520145] RPC:       state 7 conn 0 dead 0 zapped 1
[ 7749.520149] RPC:       disconnected transport ffff88013e62d800
[ 7749.520155] RPC: 33550 call_status (status -32)
[ 7749.520160] RPC: 33550 call_bind (status 0)
[ 7749.520165] RPC: 33550 call_connect xprt ffff88013e62d800 is not connected
[ 7749.520170] RPC: 33550 xprt_connect xprt ffff88013e62d800 is not connected
[ 7749.520176] RPC: 33550 sleep_on(queue "xprt_pending" time 4296829676)
[ 7749.520182] RPC: 33550 added to queue ffff88013e62db20 "xprt_pending"
[ 7749.520187] RPC: 33550 setting alarm for 60000 ms
[ 7749.520192] RPC:       xs_connect delayed xprt ffff88013e62d800 for 24 seconds
[ 7773.520041] RPC:       worker connecting xprt ffff88013e62d800 via tcp to 10.1.6.102 (port 2049)
[ 7773.520061] RPC:       ffff88013e62d800 connect status 99 connected 0 sock state 7
[ 7773.520069] RPC: 33550 __rpc_wake_up_task (now 4296835676)
[ 7773.520074] RPC: 33550 disabling timer
[ 7773.520079] RPC: 33550 removed from queue ffff88013e62db20 "xprt_pending"
[ 7773.520083] RPC:       __rpc_wake_up_task done
[ 7773.520088] RPC: 33550 __rpc_execute flags=0x1
[ 7773.520093] RPC: 33550 xprt_connect_status: retrying
[ 7773.520098] RPC: 33550 call_connect_status (status -11)
[ 7773.520103] RPC: 33550 call_transmit (status 0)
[ 7773.520107] RPC: 33550 xprt_prepare_transmit
[ 7773.520112] RPC: 33550 rpc_xdr_encode (status 0)
[ 7773.520118] RPC: 33550 marshaling UNIX cred ffff88012e002300
[ 7773.520124] RPC: 33550 using AUTH_UNIX cred ffff88012e002300 to wrap rpc data
[ 7773.520131] RPC: 33550 xprt_transmit(32920)
[ 7773.520138] RPC:       xs_tcp_send_request(32920) = -32
[ 7773.520144] RPC:       xs_tcp_state_change client ffff88013e62d800...
[ 7773.520149] RPC:       state 7 conn 0 dead 0 zapped 1
[ 7773.520153] RPC:       disconnected transport ffff88013e62d800
[ 7773.520159] RPC: 33550 call_status (status -32)
[ 7773.520164] RPC: 33550 call_bind (status 0)
[ 7773.520168] RPC: 33550 call_connect xprt ffff88013e62d800 is not connected
[ 7773.520174] RPC: 33550 xprt_connect xprt ffff88013e62d800 is not connected
[ 7773.520180] RPC: 33550 sleep_on(queue "xprt_pending" time 4296835676)
[ 7773.520186] RPC: 33550 added to queue ffff88013e62db20 "xprt_pending"
[ 7773.520190] RPC: 33550 setting alarm for 60000 ms
[ 7773.520196] RPC:       xs_connect delayed xprt ffff88013e62d800 for 48 seconds

--
Andy, BlueArc Engineering


-----Original Message-----
From: Andy Chittenden
Sent: 22 July 2010 13:19
To: Linux Kernel Mailing List (linux-kernel@vger.kernel.org)
Subject: nfs client hang

We're encountering a bug similar to http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=578152 but that claims to be fixed in the version we're running:

# dpkg --status linux-image-2.6.32-5-amd64 | grep Version:
Version: 2.6.32-17

If I do this in 4 different xterm windows having cd to the same NFS mounted directory:

xterm1: rm -rf *
xterm2: while true; do     let iter+=1;     echo $iter;     dd if=/dev/zero of=$$ bs=1M count=1000; done
xterm3: while true; do     let iter+=1;     echo $iter;     dd if=/dev/zero of=$$ bs=1M count=1000; done
xterm4: while true; do     let iter+=1;     echo $iter;     dd if=/dev/zero of=$$ bs=1M count=1000; done

then it normally hangs before the 3rd iteration starts. The directory contains loads of information (eg 5 linux source trees).

When it gets into this hang state, here's the packets from the client to server:

4       42.909478       172.18.0.39     10.1.6.102      TCP     1013 > nfs [SYN] Seq=0 Win=5840 Len=0 MSS=1460 TSV=108490 TSER=0 WS=0
5       42.909577       10.1.6.102      172.18.0.39     TCP     nfs > 1013 [SYN, ACK] Seq=0 Ack=1 Win=64240 Len=0 MSS=1460
6       42.909610       172.18.0.39     10.1.6.102      TCP     1013 > nfs [ACK] Seq=1 Ack=1 Win=5840 Len=0
7       42.909672       172.18.0.39     10.1.6.102      TCP     1013 > nfs [FIN, ACK] Seq=1 Ack=1 Win=5840 Len=0
8       42.909767       10.1.6.102      172.18.0.39     TCP     nfs > 1013 [ACK] Seq=1 Ack=2 Win=64240 Len=0
9       43.660083       10.1.6.102      172.18.0.39     TCP     nfs > 1013 [FIN, ACK] Seq=1 Ack=2 Win=64240 Len=0
10      43.660100       172.18.0.39     10.1.6.102      TCP     1013 > nfs [ACK] Seq=2 Ack=2 Win=5840 Len=0

and then repeats after a while.

IE the client starts a connection and then closes it again without sending data.

FWIW I've found it easier to reproduce this problem if Ethernet flow control is off but it still happens with it on as well. This happens with different types of Ethernet hardware too. The rm -rf isn't necessary either but makes the problem easier to reproduce (for me anyway).

The mount options are:

# mount | grep u15
sweet.dev.bluearc.com:/u15 on /u/u15 type nfs (rw,noatime,nodiratime,hard,intr,rsize=32768,wsize=32768,proto=tcp,hard,intr,rsize=32768,wsize=32768,sloppy,addr=10.1.6.102)

I've generated a 2.6.34.1 kernel and that also has the same problem.

So, why would the linux NFS client get into this "non-transmitting data" state? NB 2.6.26 doesn't exhibit this problem.

--
Andy, BlueArc Engineering


