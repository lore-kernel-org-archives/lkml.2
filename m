Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293Ab1KRNos (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 08:44:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753804Ab1KRNor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 08:44:47 -0500
Message-ID: <4EC66148.4020003@RedHat.com>
Date: Fri, 18 Nov 2011 08:44:40 -0500
From: Steve Dickson <SteveD@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110928 Fedora/3.1.15-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.15
MIME-Version: 1.0
To: John Hughes <john@Calva.COM>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add "-e" option to rpc.gssd to allow error on ticket
 expiry
References: <4EC6426A.3020306@Calva.COM>
In-Reply-To: <4EC6426A.3020306@Calva.COM>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/18/2011 06:32 AM, John Hughes wrote:
> By adding a new option to rpc.gssd the administrator can choose whether she wants the old "EACCESS on ticket expiry" or the new "wait for new ticket" behaviour.
> 
> 
I am not too keen this idea at all.... I've never been a fan of
added command line arguments for this purpose... Plus there 
is no man page update... Also please post patches in-line
the email not as email attachments...

If commit 2c64348 which causes the process to hang when 
its kerberos ticket expires is a regression... then so
be it... lets revert that commit and have the process error
out with EPERM.... It sounds like the apps would rather
have the error than the hanging... 

I think the answer to all this is have the ticket
renewed before it expires. There is a daemon call sssd
that is part of the FreeIPA project that will supposedly
do that for us... I'm looking into it... 

steved.
 
