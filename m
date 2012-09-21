Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab2IUAW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 20:22:28 -0400
Received: from nm16-vm0.bullet.mail.ukl.yahoo.com ([217.146.183.254]:40554
	"HELO nm16-vm0.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754073Ab2IUAW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 20:22:27 -0400
X-Greylist: delayed 346 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Sep 2012 20:22:26 EDT
X-Yahoo-Newman-Id: 21826.17650.bm@smtp141.mail.ukl.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: zeqmhGIVM1nH6pXpHdw3KnRzxIB9J3coxFAi9yT6ww47jks
 QDagmGbCJvdlJKeYK_82xCa88zcQWt0rAVumOU53TGwvabi7RcOS72TxKnYV
 5cksz_MGuiTA5EyYifBdXwiXbvlHdtzNLYwUJBYg0Fnd8vZe6iGLRa0BJjQp
 .qJsyL17slhIyM01.IKTfsmXf8m93TXI0CcHecP6EeQrMDamPY.uauPRVZnD
 f7t_ZsjUgFBGXXroMDfgFdpfi7CRKf79t5hmW0bkbuyyo9CpwtH_yyF3r6NT
 _YBTvC_Rvd310v_Xu3IsbPDYfP3I2bBWMZ_mGHkbgicy2lI04ADhOpcnV3Ja
 zqA7_aQCbqzhXv._ROXv3k333MZKIrhP_Od2Tfl.U6JGPuXSXydR4rF.b4qK
 CUMOlyTq_sK_vwZhLSANc
X-Yahoo-SMTP: 5Vuzu2WswBCxMnJ0hjKohBcp6M6Es6bt5AQ-
Message-ID: <505BB1E6.3010502@yahoo.com>
Date: Fri, 21 Sep 2012 01:16:38 +0100
From: Paul Parsons <lost.distance@yahoo.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: dwmw2@infradead.org, philipp.zabel@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pda_power: ac_draw used before set
References: <505A0293.4070708@yahoo.com> <20120920213232.GA18223@lizard>
In-Reply-To: <20120920213232.GA18223@lizard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Anton,

On 20/09/12 22:32, Anton Vorontsov wrote:
> On Wed, Sep 19, 2012 at 06:36:19PM +0100, Paul Parsons wrote:
>> When I reboot my iPAQ hx4700 in its cradle, the battery will not begin
>> to charge even though the AC supply is connected. Charging will start
>> only after the PDA power driver is tickled by some other power event,
>> such as reseating the iPAQ in its cradle or connecting the USB cable.
>>
>> The problem lies in pda_power_probe(), where ac_draw is used by the call
>> to update_charger() before being set by the call to regulator_get().
>>
>> Moving the regulator_get() call to before the update_charger() call
>> fixes the problem.
>>
>> Signed-off-by: Paul Parsons <lost.distance@yahoo.com>
>> Cc: Philipp Zabel <philipp.zabel@gmail.com>
>> ---
>
> Great to see that someone is still using hx4700. :-)
>
> Thanks for the patch, it is merged now!

I am having second thoughts about the goto ac_draw_failed I added.
This will cause pda_power_probe() to fail if regulator_get() fails.
However the way ac_draw is used - always after a check for NULL -
suggests that a failed call to regulator_get() was not fatal.

I am happy to submit another patch to remove the goto and label.

Regards,
Paul
