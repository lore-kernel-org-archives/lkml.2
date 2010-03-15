Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965429Ab0COQoG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 12:44:06 -0400
Received: from mail-gw26.credit-suisse.com ([198.240.213.9]:50194 "EHLO
	mail-gw26.credit-suisse.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932612Ab0COQoB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 12:44:01 -0400
X-Greylist: delayed 359 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Mar 2010 12:44:00 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Subject: RE: Seeing TCP socket options (nodelay, cork, etc) in Linux procfs or elsewhere?
Date: Mon, 15 Mar 2010 16:40:26 -0000
Message-ID: <5608FA8A997F1A46B7E985494F8478DD07930AF3@ELON17P32003A.csfb.cs-group.com>
In-Reply-To: <5608FA8A997F1A46B7E985494F8478DD07930AF2@ELON17P32003A.csfb.cs-group.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Seeing TCP socket options (nodelay, cork, etc) in Linux procfs or elsewhere?
thread-index: AcrEW3U66fgmssVtQSaFIfapDSkHsgAATifwAABG0rA=
References: <5608FA8A997F1A46B7E985494F8478DD07930AF1@ELON17P32003A.csfb.cs-group.com> <1268670031.3154.35.camel@edumazet-laptop> <5608FA8A997F1A46B7E985494F8478DD07930AF2@ELON17P32003A.csfb.cs-group.com>
From: "MacCana, Mike" <mike.maccana@credit-suisse.com>
To: "MacCana, Mike" <mike.maccana@credit-suisse.com>,
       "Eric Dumazet" <eric.dumazet@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 15 Mar 2010 16:40:27.0181 (UTC) FILETIME=[3792ADD0:01CAC45E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-----Original Message-----
From: Eric Dumazet [mailto:eric.dumazet@gmail.com]
Sent: 15 March 2010 16:21
To: MacCana, Mike
Cc: linux-kernel@vger.kernel.org
Subject: Re: Seeing TCP socket options (nodelay, cork, etc) in Linux procfs or elsewhere?

>Le lundi 15 mars 2010 à 15:49 +0000, MacCana, Mike a écrit :
>> Hi kernel folks,
>>  
>> I was wondering if there was a standard location to see TCP socket 
>> options (eg, nodelay, cork, etc), perhaps via procfs or some other 
>> means? I'd like to check whether arbitrary apps (for which I don't 
>> have
>> code) are using particular TCP options. 
>>  
>> Wandering round /proc/net hasn't turned up anything yet, and after a
>> quick:
>> socket.setsockopt(0, 1, 1)
>> to enable NODELAY I can't see any obvious difference in procfs or 
>> netstat output (where other Unixes seem to put this info). hat's the 
>> best way to see TCP options on sockets created by others' code?
>> 

>There is limited support given by ss command (part of iproute2) :
>
>ss -emoi
>
>ESTAB       0      0                                55.225.18.5:4900
>55.225.18.5:50000    uid:501 ino:135421 sk:c3b405c0
>	 mem:(r0,w0,f4096,t0) ts bic wscale:6,6 rto:201 rtt:1/0.5 ato:40 
>cwnd:3 send 393.2Mbps rcv_space:32768
>
> But CORK flag is not exported yet (its usually a volatile flag, at 
> least with Apache server)

Thanks Eric. Checking here:

# sockettest.settcpoption(serversocket,'nodelay',True)    

# ss -emoi
LISTEN     0      5                 127.0.0.1:7778                     *:*      ino:4095699 sk:0a53b500ffff8100

<my last reply was truncated>

I can't get NODELAY either. Looking at lsof FAQ Linux seems to be limited in this regard. 

3.14.1	Why doesn't lsof report socket options, socket states, and TCP
	flags and values for my dialect?

Linux
		No socket options and values, socket states, or TCP
		flags and values are reported.  The support for "-Tf"
		could not be added to Linux, because socket options,
		socket states, and TCP flags and values are not
		available via the /proc file system.

However the SystemTap Networking Tapset provides a tcp.setsockopt breakpoint which I can use.

Mike

1. http://gd.tuwien.ac.at/utils/admin-tools/lsof/FAQ
2. http://www.redhat.com/docs/en-US/Red_Hat_Enterprise_Linux/pdf/SystemTap_Tapset_Reference.pdf








=============================================================================== 
 Please access the attached hyperlink for an important electronic communications disclaimer: 
 http://www.credit-suisse.com/legal/en/disclaimer_email_ib.html 
 =============================================================================== 
 
