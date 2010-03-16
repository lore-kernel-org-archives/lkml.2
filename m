Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759973Ab0CPSZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 14:25:10 -0400
Received: from mail-gw26.credit-suisse.com ([198.240.213.9]:28222 "EHLO
	mail-gw26.credit-suisse.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759959Ab0CPSZH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 14:25:07 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Subject: RE: Seeing TCP socket options (nodelay, cork, etc) in Linux procfs or elsewhere?
Date: Tue, 16 Mar 2010 18:24:58 -0000
Message-ID: <5608FA8A997F1A46B7E985494F8478DD07930AFA@ELON17P32003A.csfb.cs-group.com>
In-Reply-To: <5608FA8A997F1A46B7E985494F8478DD07930AF3@ELON17P32003A.csfb.cs-group.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Seeing TCP socket options (nodelay, cork, etc) in Linux procfs or elsewhere?
thread-index: AcrEW3U66fgmssVtQSaFIfapDSkHsgAATifwAABG0rAANfBqkA==
References: <5608FA8A997F1A46B7E985494F8478DD07930AF1@ELON17P32003A.csfb.cs-group.com> <1268670031.3154.35.camel@edumazet-laptop> <5608FA8A997F1A46B7E985494F8478DD07930AF2@ELON17P32003A.csfb.cs-group.com> <5608FA8A997F1A46B7E985494F8478DD07930AF3@ELON17P32003A.csfb.cs-group.com>
From: "MacCana, Mike" <mike.maccana@credit-suisse.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 16 Mar 2010 18:24:59.0306 (UTC) FILETIME=[FC76C0A0:01CAC535]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
From: Eric Dumazet [mailto:eric.dumazet@gmail.com]
Sent: 15 March 2010 16:21
To: MacCana, Mike
Cc: linux-kernel@vger.kernel.org
Subject: Re: Seeing TCP socket options (nodelay, cork, etc) in Linux procfs or elsewhere?

>>Le lundi 15 mars 2010 à 15:49 +0000, MacCana, Mike a écrit :
>>> Hi kernel folks,
>>>  
>>> I was wondering if there was a standard location to see TCP socket 
>>> options (eg, nodelay, cork, etc), perhaps via procfs or some other 
>>> means? I'd like to check whether arbitrary apps (for which I don't 
>>> have
>>> code) are using particular TCP options. 

> the SystemTap Networking Tapset provides a tcp.setsockopt breakpoint which I can use.
> Mike

Here's the tap I used (included for anyone reading on a list archive if there's still no /proc implementation):

sockettest.stap
# Show sockets setting options
probe begin
{
	print ("\nChecking for apps making socket calls\n")
}
probe tcp.setsockopt
{
	printf ("  App '%s' (PID %d) set socket with args %s \n", execname(), pid(), optstr)
}

Mike

=============================================================================== 
 Please access the attached hyperlink for an important electronic communications disclaimer: 
 http://www.credit-suisse.com/legal/en/disclaimer_email_ib.html 
 =============================================================================== 
 
