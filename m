Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab1DVDzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 23:55:50 -0400
Received: from smtp105.prem.mail.sp1.yahoo.com ([98.136.44.60]:34306 "HELO
	smtp105.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754159Ab1DVDzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 23:55:49 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: chtUXJwVM1nn3EMOE3EyoI41XcY10opTRrTXL0Z_g2ObyAe
 pDo5l3i_URO_F0bPz3VE8xf.flYxc9AcYrRajWNLf_keSCYAZUwj4s83HtCM
 DnJVXy0BiGrtww.k2BxKi_eyMkhKYJFrG1Qew4B46pGw8fQWTtAWvpjGlPLc
 _Zce7CYEZlEPs62qnhZO8X1qic0Xwqv6VP81voOVL6dvA3sJdiX6mEVF4wKi
 d6Z69OELou8AJEG.3qefiQC_UsSY6CrvulKOjyXRSMiuEeJUXuwam3.347PD
 vxbHxOEQrUamZH79G.oIgb_eIPCz0OcqZ2Wwnu7ql_QQOBgZMmPSXFZUElCw
 h35d6lekEaYS7o3e61JfODUX9V7tJh9MHQA--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4DB0FC43.8000800@schaufler-ca.com>
Date: Thu, 21 Apr 2011 20:55:47 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andi Kleen <ak@linux.intel.com>, jmorris@namei.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SMACK: Add missing rcu_read_lock/unlock for process capability
 walk.
References: <1303336844-31074-1-git-send-email-andi@firstfloor.org> <4DAF637D.90606@schaufler-ca.com> <20110420231859.GB32402@tassilo.jf.intel.com> <4DAF6FA5.7080801@schaufler-ca.com> <20110421000818.GT16484@one.firstfloor.org> <4DAF7EAC.8010504@schaufler-ca.com> <20110421155832.GU16484@one.firstfloor.org>
In-Reply-To: <20110421155832.GU16484@one.firstfloor.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/21/2011 8:58 AM, Andi Kleen wrote:
> On Wed, Apr 20, 2011 at 05:47:40PM -0700, Casey Schaufler wrote:
>> On 4/20/2011 5:08 PM, Andi Kleen wrote:
>>>> The global list, yes. The task specific list, no. Modifying the local
>>>> list is like any other modification of the cred structure and requires
>>>> the cred be copied.
>>> But you still need to free it eventually right? And that freeing will
>>> need RCU on the reader.
>> Entries are never freed from the global list. Someone is working
>> on a patch to do that, but is running into - wait for it - locking
>> issues.
> Then why do you use rcu_read_lock() at all? 

Because the entries can be modified in place.

> You can drop all the rcu_read_lock()s and probably the other *_rcu 
> list accesses then. And my patch is indeed not needed. 
>
>> Entries on the local lists are only freed when the task exits.
> You mean the last user of the cred?

Yes.

> -Andi
>

