Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139Ab1DMKFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 06:05:35 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40720 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab1DMKFd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 06:05:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:message-id:in-reply-to:user-agent;
        b=bMIl0e2bu/hJJOe58Jw/kN08ccD2WOwBKwe26Z/XOzKZO77FetoJR+qJYDyguJSDvy
         QNTzMHiC7Jwc0IXcpJEta1DvvBu0fbj3ApzzKvLeuLDiKT+A8clX6uytawQzl7nmkavn
         rb7Z/VIndrCvkle/FgVQXzkselH5avr2F9ixI=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "'Sebastian Andrzej Siewior'" <bigeasy@linutronix.de>,
        "Tanya Brokhman" <tlinder@codeaurora.org>
Cc: gregkh@suse.de, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        ablay@codeaurora.org,
        "'open list:USB GADGET/PERIPH...'" <linux-usb@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RESEND 3/5 v4] usb: Configure endpoint according to gadget
 speed.
References: <1300867445-20911-1-git-send-email-tlinder@codeaurora.org>
 <20110411141404.GC4018@linutronix.de> <001701cbf9c1$11875fc0$34961f40$@org>
Date: Wed, 13 Apr 2011 12:05:29 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vtvfnf1t3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <001701cbf9c1$11875fc0$34961f40$@org>
User-Agent: Opera Mail/11.01 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Apr 2011 11:56:27 +0200, Tanya Brokhman  
<tlinder@codeaurora.org> wrote:

>> >+	/* find descriptors */
>> >+	for (d_spd = next_ep_desc(speed_desc); d_spd;
>> >+	      d_spd = next_ep_desc(d_spd+1)) {
>>
>> this might look better if you would something like the list_for_each()
>> macro.
>
> The function next_ep_desc() goes over the endpoint descriptors (struct
> usb_descriptor_header). It's not a list so I don't see how the
> list_for_each() macro can be used here. Am I missing something?

What op[1] meant was to create a for_each_ep_desc() macro, eg. (not  
tested):

#define for_each_ep_desc(it, start) \
         for (it = (start); (it = next_ep_desc(it)); ++it)

>> > /**
>> >+ * config_ep_by_speed() - configures the given endpoint
>> >+ * according to gadget speed.
>> >+ * @g: pointer to the gadget
>> >+ * @f: usb function
>> >+ * @_ep: the endpoint to configure
>> >+ *
>> >+ * Return: error code, 0 on success
>> >+ *
>> >+ * This function chooses the right descriptors for a given
>> >+ * endpoint according to gadget speed and saves in in the
>> >+ * endpoint desc field. If the endpoint already has a descriptor
>> >+ * assigned to it - overwrites it with currently corresponding
>> >+ * descriptor. The endpoint maxpacket field is updated according
>> >+ * to the choosen descriptor.
>> >+ * Note: the supplied function should hold all the descriptors
>> >+ * for supported speeds
>> >+ */
>>
>> You have the same comment (including the same typo) here and in the .c.
>> Please use only on (in the .c file) as they will go async.
>
> Thanks for noticing that!
> What do you mean by "they will go async"? Is there some sort of  
> automation
> that updates the comments for functions from c files to the headers?

There's none.  That's the problem.  Someone will modify comment in one of  
them
and will forget to modify it in the other.  That's why it's better to keep
comments in one place only.

[1] Also, please leave the attribution lines (the “On ... someone wrote:”
     lines) in replies.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
