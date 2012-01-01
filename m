Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391Ab2AAX1W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 18:27:22 -0500
Received: from lo.gmane.org ([80.91.229.12]:56311 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033Ab2AAX1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 18:27:19 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Gene Smith <gds@chartertn.net>
Subject: Re: wifi iwlagn fails to authenticate after wake from suspend
Date: Sun, 01 Jan 2012 18:26:59 -0500
Message-ID: <jdqq44$7d9$1@dough.gmane.org>
References: <j881g5$tdf$1@dough.gmane.org>  <alpine.DEB.2.00.1110252325090.20273@chino.kir.corp.google.com>  <j8fvka$fu0$1@dough.gmane.org>  <CA+tb8OUHNbhVN_KiEkqXJW1apFoExRM5Vrn=ES5SF3sFoGOMfA@mail.gmail.com> <1323701322.1806.24.camel@wwguy-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 24-158-184-117.dhcp.jcsn.tn.charter.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
In-Reply-To: <1323701322.1806.24.camel@wwguy-ubuntu>
Cc: linux-wireless@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2011 09:48 AM, wwguy wrote:
> On Sun, 2011-12-11 at 22:36 -0800, Matías Aguirre wrote:
>> Hi,
>>
>> On Sat, Oct 29, 2011 at 2:32 AM, Gene Smith<gds@chartertn.net>  wrote:
>>> David Rientjes wrote, On 10/26/2011 02:27 AM:
>>>> So we need to bisect between 2.4.38 and 3.0.0? :)  I'm running ubuntu
>>>> 11.10 on a home laptop so I'll give this a try as well when I can if I can
>>>> put up with unity for that long.
>>
>> I've bisected the problem and narrowed the bug to changeset 73b78a2272
>> (http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=73b78a22720087d2d384bdd49e9c25500ba73edd).
>>
>> Here's a patch, that applies against 3.2-rc5, that fixed the error for me:
>>
>> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c
>> b/drivers/net/wireless/iwlwifi/iwl-agn.c
>> index bacc06c..01d5d38 100644
>> --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
>> +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
>> @@ -1297,7 +1297,7 @@ int iwl_alive_start(struct iwl_priv *priv)
>>                                           BT_COEX_PRIO_TBL_EVT_INIT_CALIB2);
>>                  if (ret)
>>                          return ret;
>> -       } else {
>> +       } else if (priv->cfg->bt_params) {
>>                  /*
>>                   * default is 2-wire BT coexexistence support
>>                   */
> this is not right, you stop the bt coex for non-combo device.
> maybe you system has issue with BT, we seen this happen on some cases.
> try the following module parameter and see if help
>
> $sudo modprobe iwlagn bt_coex_active=0
>
> Thanks
> Wey
>

Unfortunately the latest fedora 16 kernel, 3.1.6-1.fc16.x86_64, renders 
this fix
ineffective and again cannot resume wifi after a sleep and must reboot.
Therefore must stay with older kernels for this to work and for wifi to 
resume
after sleep:
3.1.5-6.fc16 is still OK with bt_coex_active=0
3.1.5-2.fc16 is also still OK with this fix.




