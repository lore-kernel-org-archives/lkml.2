Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885Ab1EXEdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 00:33:45 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:44351 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab1EXEdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 00:33:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=iE2+BlM6UmOf+Udn8VyBpZtRJxEfm8AgfwWvFMtHT9yALDzRqYciGfLkyHcyX24MhJ
         kkwjjey9SAhoWq6CChT6g2cYSPyAFaflUuFnOwNC63npM24A2QWbJBf61nxPeubaO0M/
         SzaZTaH69VElWNBc3KhTK+0oJ284tIrpGBfyY=
Message-ID: <4DDB3518.4040808@gmail.com>
Date: Mon, 23 May 2011 21:33:28 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: netdev@vger.kernel.org, davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]net:8021q:vlan.c Fix pr_info to read on line in the syslog.
References: <1306166698-2036-1-git-send-email-justinmattock@gmail.com> <1306167781.8687.20.camel@Joe-Laptop>
In-Reply-To: <1306167781.8687.20.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2011 09:23 AM, Joe Perches wrote:
> On Mon, 2011-05-23 at 09:04 -0700, Justin P. Mattock wrote:
>> The patch below changes the pr_info so that it reads on one line in the syslog
>> rather than two.
>>
>> before:
>>
>> [   30.438203] 802.1Q VLAN Support v1.8 Ben Greear<greearb@candelatech.com>
>> [   30.441542] All bugs added by David S. Miller<davem@redhat.com>
>>
>>
>> after:
>> [   29.356282] 802.1Q VLAN Support v1.8 Ben Greear<greearb@candelatech.com>  All bugs added by: David S. Miller<davem@redhat.com>
>>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   net/8021q/vlan.c |    4 ++--
>>   1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
>> index b2274d1..02f4d8b 100644
>> --- a/net/8021q/vlan.c
>> +++ b/net/8021q/vlan.c
>> @@ -673,8 +673,8 @@ static int __init vlan_proto_init(void)
>>   {
>>   	int err;
>>
>> -	pr_info("%s v%s %s\n", vlan_fullname, vlan_version, vlan_copyright);
>> -	pr_info("All bugs added by %s\n", vlan_buggyright);
>> +	pr_info("%s v%s %s All bugs added by: %s\n", vlan_fullname, vlan_version,
>> +		vlan_copyright, vlan_buggyright);
>
> Might as well avoid the format string then too.
>
> 	pr_info(vlan_fullname " v" vlan_version " " vlan_copyright
> 		" All bugs added by: " vlan_buggyright "\n");
>
> or just kill the otherwise unused vlan_<foo>  variables
>
> 	pr_info("802.1Q VLAN Support v" vlan_version
> 		" Ben Greear<greearb@candelatech.com>"
> 		" All bugs added by: David S. Miller<davem@redhat.com>\n");
>
> though I think that emitting names on startup isn't necessary and
> this is enough:
>
> 	pr_info("802.1Q VLAN Support v" vlan_version "\n");
>
>
>

alright, I will resend this with what you have then.

Justin P. Mattock
