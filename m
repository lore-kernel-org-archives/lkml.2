Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab2KHLxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 06:53:45 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:53714 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab2KHLxo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 06:53:44 -0500
MIME-Version: 1.0
In-Reply-To: <509B5BDC.3030005@ti.com>
References: <1352299488-11351-1-git-send-email-peter.ujfalusi@ti.com>
	<1352299488-11351-3-git-send-email-peter.ujfalusi@ti.com>
	<CANOLnOM7sp+O+KBKjiRk2drWh_63D6-bY86dx+upWkrvs7pp9w@mail.gmail.com>
	<509B5BDC.3030005@ti.com>
Date: Thu, 8 Nov 2012 13:53:43 +0200
Message-ID: <CANOLnOM6dp2_WthKUo31X_0os4cwax9Y42qSLqi09XiR-HF-Uw@mail.gmail.com>
Subject: Re: [PATCH 2/3] pwm: New driver to support PWMs on TWL4030/6030
 series of PMICs
From: Grazvydas Ignotas <notasas@gmail.com>
To: =?ISO-8859-1?Q?P=E9ter_Ujfalusi?= <peter.ujfalusi@ti.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Tero Kristo <t-kristo@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 8, 2012 at 9:14 AM, Péter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> On 11/07/2012 06:50 PM, Grazvydas Ignotas wrote:
>>> +       if (pwm->hwpwm) {
>>> +               /* PWM 1 */
>>> +               mask = TWL4030_GPIO7_VIBRASYNC_PWM1_MASK;
>>> +               bits = TWL4030_GPIO7_VIBRASYNC_PWM1_PWM1;
>>> +       } else {
>>> +               /* PWM 0 */
>>> +               mask = TWL4030_GPIO6_PWM0_MUTE_MASK;
>>> +               bits = TWL4030_GPIO6_PWM0_MUTE_PWM0;
>>> +       }
>>> +
>>> +       /* Save the current MUX configuration for the PWM */
>>> +       twl->twl4030_pwm_mux &= ~mask;
>>> +       twl->twl4030_pwm_mux |= (val & mask);
>>
>> Do we really need this mask clearing here? After probe twl4030_pwm_mux
>> should be zero, and if twl4030_pwm_request is called twice you don't
>> clear the important bits before |=, I think 'twl4030_pwm_mux = val &
>> mask' would be better here.
>
> I'm storing both PWM's state in the same variable, but in different offsets:
> PWM0: bits 2-3
> PWM1: bits 4-5
> Probably it is over engineering to clear the relevant bits in the backup
> storage, but better to be safe IMHO.
> I would leave this part as it is.

Oh, it should be good then.


-- 
Gražvydas
