Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab2K3WSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 17:18:50 -0500
Received: from smtp105.biz.mail.bf1.yahoo.com ([98.139.221.43]:49101 "HELO
	smtp105.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751225Ab2K3WSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 17:18:48 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 9rcgXvQVM1l7fWk3jfuVKZ060NyfivDYtX13p2e4EUb15W2
 oEwrD0cmWBG3jymr600S2QdT4d7MUuihzGhKAs6eEnPgm5kEYEZUblSX84ZZ
 p.chVWZEJ_7ihcozBOdN0vLiiFtElXwpkdYTRB5n5yGF.Hgb4YzcujMhVl97
 VndjDad1RtMFMNLEehQSBUKPcLx4DMRLhdhmsfjIVbQq4bO6l50ryzdTjBsm
 aJBvs5p6vSIgzZRTK1QTpsSxLIrs9krKWrUdS.zwkBTV3Uzaqj3EBZwvXWqr
 LbnA1a4iBhXw2e9BB5CfjtNozpuVzk4JkH39GE8ranLDN1ca1ElV.QeTo0f_
 zLOEDU0SbbJqv5X3HjAdwArQWK84.Dx8ObaOHW7eF9tuXNDuoKmuLdzzCsX3
 KKm6iZbjfWHDrKAcEpl3tgq.4dPKyuQ3VSI5uTIs2hzyy7nmWs.qRop4zzqm
 6CwrUEuzCa3dzzZN4gCzSnyJYdrkWWw91SSqcZU3387CY9zXSmG6UE5eccdP
 1u0l.vC83gigly2fmkpYkFH.YFfjIQmAUjC2lr8sAqf6nS5cOZAoRF4s-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <50B930CE.1080806@schaufler-ca.com>
Date: Fri, 30 Nov 2012 14:18:54 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Eric Paris <eparis@parisplace.org>
CC: Randy Dunlap <rdunlap@xenotime.net>, Paul Moore <paul@paul-moore.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] Smack: Add missing depends on INET in Kconfig
References: <20121129174057.99da02b15426c76054d05592@canb.auug.org.au> <50B7F846.70202@infradead.org> <3694027.VYznNcdp7C@sifl> <2664553.2TRaVqlkGg@sifl> <50B8E4E6.2040901@xenotime.net> <50B8ECB3.2090801@schaufler-ca.com> <CACLa4ptazSZCpk5Ug0mZLZRS1PxZ7KnwYxEXsXFwn3zG90YzNg@mail.gmail.com>
In-Reply-To: <CACLa4ptazSZCpk5Ug0mZLZRS1PxZ7KnwYxEXsXFwn3zG90YzNg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2012 2:01 PM, Eric Paris wrote:
> Do other LSMs need this too Casey?  I remember we mentioned how select
> was dangerous  :-(

I don't see any missing dependencies, but then, I missed INET.
Yes, you mentioned that it was dangerous.

>
> On Fri, Nov 30, 2012 at 12:28 PM, Casey Schaufler
> <casey@schaufler-ca.com> wrote:
>> Because NETLABEL depends on INET SECURITY_SMACK
>> has to explicitly call out the dependency.
>>
>> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
>> ---
>>  security/smack/Kconfig |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/security/smack/Kconfig b/security/smack/Kconfig
>> index 9fb14ef..1be1088 100644
>> --- a/security/smack/Kconfig
>> +++ b/security/smack/Kconfig
>> @@ -1,5 +1,6 @@
>>  config SECURITY_SMACK
>>         bool "Simplified Mandatory Access Control Kernel Support"
>> +       depends on INET
>>         depends on NET
>>         depends on SECURITY
>>         select NETLABEL
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/

