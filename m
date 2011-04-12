Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319Ab1DLSnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 14:43:14 -0400
Received: from mx2.netapp.com ([216.240.18.37]:53937 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756451Ab1DLSnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 14:43:12 -0400
X-IronPort-AV: E=Sophos;i="4.64,198,1301900400"; 
   d="scan'208";a="540883544"
Message-ID: <4DA49D3A.7090800@netapp.com>
Date: Tue, 12 Apr 2011 14:43:06 -0400
From: Bryan Schumaker <bjschuma@netapp.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Lightning/1.0b2 Lanikai/3.1.9
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        ML netdev <netdev@vger.kernel.org>, linux-nfs@vger.kernel.org
Subject: Re: [PATCH] NFS: Fix infinite loop in gss_create_upcall()
References: <201103312224.p2VMOA5g000983@imap1.linux-foundation.org>	 <4D96E4C5.2080302@suse.cz> <1302122693.16786.0.camel@lade.trondhjem.org>	 <4D9D5CC9.2040002@suse.cz> <4DA36722.2020402@suse.cz>	 <4DA36758.4070203@suse.cz> <4DA36DB6.8060108@suse.cz>	 <4DA48EB0.40600@netapp.com>  <4DA4946D.5020403@suse.cz> <1302633088.4801.48.camel@lade.trondhjem.org> <4DA49B49.1020005@suse.cz>
In-Reply-To: <4DA49B49.1020005@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2011 02:34 PM, Jiri Slaby wrote:
> On 04/12/2011 08:31 PM, Trond Myklebust wrote:
>>> Yes, it fixes the problem. But it waits 15s before it times out. This is
>>> inacceptable for automounted NFS dirs.
>>
>> I'm still confused as to why you are hitting it at all. In the normal
>> autonegotiation case, the client should be trying to use AUTH_SYS first
>> and then trying rpcsec_gss if and only if that fails.
>>
>> Are you really exporting a filesystem using AUTH_NULL as the only
>> supported flavour?
> 
> I don't know, I connect to a nfs server which is not maintained by me.
> It looks like that. How can I find out?

If you're not using gss for anything, you could try rmmod-ing rpcsec_gss_krb5 (and other rpcsec_gss_* modules).

- Bryan

> 
> thanks,

