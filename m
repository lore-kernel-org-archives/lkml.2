Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab2LUKu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 05:50:56 -0500
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:52014 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751603Ab2LUKur convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 05:50:47 -0500
From: Loic PALLARDY <loic.pallardy@st.com>
To: "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
Cc: Loic PALLARDY STE <loic.pallardy-ext@stericsson.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Gutierrez, Juan" <jgutierrez@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        Dom Cobley <popcornmix@gmail.com>, Wim Van Sebroeck <wim@iguana.be>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>, Tejun Heo <tj@kernel.org>,
        "Anna, Suman" <s-anna@ti.com>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 21 Dec 2012 11:50:01 +0100
Subject: Re: [PATCH 4/9] mailbox: create opened message type
Thread-Topic: [PATCH 4/9] mailbox: create opened message type
Thread-Index: Ac3faO3Dh/krb8ZeQQKq/L0wRg7D2A==
Message-ID: <50D43ED9.4030906@st.com>
References: <1355836212-17956-1-git-send-email-loic.pallardy-ext@stericsson.com>
 <1355836212-17956-5-git-send-email-loic.pallardy-ext@stericsson.com>
 <B5906170F1614E41A8A28DE3B8D121433EC9CE7A@DBDE01.ent.ti.com>
In-Reply-To: <B5906170F1614E41A8A28DE3B8D121433EC9CE7A@DBDE01.ent.ti.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120412
 Thunderbird/11.0.1
acceptlanguage: fr-FR, en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/21/2012 11:28 AM, Bedia, Vaibhav wrote:
> On Tue, Dec 18, 2012 at 18:40:07, Loic Pallardy wrote:

>> -	msg = mbox_read_reg(fifo->data);
>> -	msg |= ((mbox_msg_t) mbox_read_reg(fifo->cmd))<<  16;
>> +	msg->header = mbox_read_reg(fifo->data);
>> +	msg->header |= ((mbox_msg_t) mbox_read_reg(fifo->cmd))<<  16;
>
> Now that struct mailbox_msg encapsulates the data, you can
> get rid of the mbox_msg_t typedef completely. Having the data
> as part of the mailbox_msg along with the functions with mbox_msg_t
> as the return type just creates confusion IMHO.
>
OK I'll clean up mbox_msg_t typedef.
>>
>> -	return msg;
>> +	return 0;
>>   }
>
> Convert all return 0 functions to void?
>
> [...]
>
Yes, agree I'll change the prototype.
>>
>> +
>> +#define MAILBOX_FILL_HEADER_MSG(_msg, _header) \
>> +	MAILBOX_FILL_MSG(_msg, _header, NULL, 0);
>> +
>
> I used these patches as part of the suspend-resume support for AM335x
> which has the same mailbox IP as OMAP4. I used the MAILBOX_FILL_HEADER_MSG
> helper and things work as expected.

Nice.
>
> However, I found the 'header' part to be very confusing. Why not treat the
> OMAP case as a special case of the new MAILBOX_FILL_MSG where the data size
> is set to 1?

Yes it is another possibility. Changes are not big.
Omar, what's your view on this point?

Regards,
Loic
>
> Regards,
> Vaibhav