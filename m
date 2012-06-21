Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475Ab2FUTeM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 15:34:12 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:44898 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756257Ab2FUTeL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 15:34:11 -0400
References: <8495990E-0B78-4B47-A00D-36D45DC3450F@gmail.com> <CACRpkdZZmxqus6jujtq43qD_d_dHxi2wORmC18kGsD3aB1jjAQ@mail.gmail.com> <20120604091127.0f95a85c@archvile> <73B37CBF-9E2A-49F5-9CA9-8CFBEF3666D6@gmail.com> <20120620170126.311b8eef@archvile> <9C01B236-B051-40D2-9805-F8B8F308827D@gmail.com> <20120621091054.57a69b8c@archvile>
In-Reply-To: <20120621091054.57a69b8c@archvile>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <D58154AE-36F8-45BD-BBB3-CF1AC3F4E610@gmail.com>
Content-Transfer-Encoding: 8BIT
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        open list <linux-kernel@vger.kernel.org>
From: =?iso-8859-1?Q?Jean-Fran=E7ois_Dagenais?= <jeff.dagenais@gmail.com>
Subject: Re: gpio: pca953x: interrupt feature unreliable
Date: Thu, 21 Jun 2012 15:34:07 -0400
To: David Jander <david.jander@protonic.nl>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear David!

On 2012-06-21, at 3:10 AM, David Jander wrote:

> On Wed, 20 Jun 2012 15:28:05 -0400
> Jean-François Dagenais <jeff.dagenais@gmail.com> wrote:
> 
>> (putting Linus in CC 'cause I hear he enjoys interaction with hardware. As do I,
>> and this is a funny hard/soft timing issue, insignificant maybe in the large
>> scale of the kernel, but an interesting puzzle. Sorry if doing so is out-of-line.
> 
> Oh dear. Well, if you really need to do that.... ;-)
> I hope we are not boring the hell out of a lot of people with this silly
> discussion. My excuses to the rest of the CC if we are...

I personally think the "silliness" of the discussion is still in debate. It may be silly in the grand context of the kernel, I agree, but definitely core for pca953x users. I merely involved torvalds for the kick of tricky timing issues and register specs, not to attract a parade on this. Removed on this reply, he can follow if he's interested on the list. Sorry if any etiquette was violated.

> 
>> Of course, I found out about this while "proof of concept"ing chaining the
>> AD714X INT to a PCA9555. The product this goes in is not in production yet.
> 
> Phew! Then what's the problem?

Uuuh, I'm good myself thanks ;) but the problem is this is not a reliable interrupt controller (in the general sense), especially the way the current driver works with it.

> ...
> Easy: Just release the button and push it again ;-)
> (I mentioned our application was a gpio_keys keyboard in my previous e-mail.)

Yeah I had missed that you were doing one key per GPIO... But that's indeed why you are fine with it. You are using it more like a keyboard driver with an interrupt controller. If you use the 953x as an actual interrupt "controller" for a client that has a hardware-logic controlled INT signal, it won't be reliable for such an application (with the current driver state), contrary to what the driver initially suggests.

> That's the kind of applications you can use the PCA953x as interrupt
> controller for. My patches incorporated support for device-tree bindings and a
> few fixes for both gpio-pca953x.c and gpio_keys.c, so it became possible to do
> just this in a device-tree:
> 		...
> 
> Get the idea? There is no other code involved, and it "just works"! I am
> absolutely amazed by this marvel ;-)

I wasn't familiar with device-tree, thanks for this intro, I will look into it more. Not being familiar, I couldn't make this part out properly: are each of your keys using their own nested IRQ? 

> ...
>> Since the timings of the slave and the OS are factors here, it's quite hard to
>> reproduce. Even with the best intention and diligence at design, a race is
>> possible.
> 
> Yes, of course. But that is a shortcoming of the extremely simple design of
> PCA953x gpio expanders. There is not much we can do about this in the driver.

Well, what about my original suggestion? I know you said you agree with serving on only LEVEL, but it had a few other specifics... I guess at this point, my idea would have to be backed by tests and a patch. (Hearing you tell me: Yeah JF, why don't you put your money where your mouth is!? ;)

> Maybe we could place a warning in the documentation about the shortcomings of
> these chips...?

Ok, now we are starting to agree! ;-) Short of an actual mod patch to the driver with results, I think this is a minimum. It could save a lot of people a lot of time, and perhaps save some aggravation too.

> Never mind. I am a hardware designer myself and we all make such mistakes.
> Just try not to blame someone or something else for it publicly ;-)

I'm sorry if you felt my interventions here had anything to do with blame, to you or anyone. I was merely acting on the behalf of helping others avoid encountering issues with this, and saving other engineers some time from my own experiences. And in the spirit of giving back since I take so much from the open source community. I know it sounds corny, but it's still true.

> 
> Feel free to improve the driver... but please do not remove features that work
> for others.

Indeed. Hence why I try to get feedback about my improvement idea. It has effects on current users since the interrupt clients would have to adjust since instead of providing EDGE based, it would provide only LEVEL, plus, in existing designs, the pca953x would now ask that it's own interrupt be EDGE(RISING|FALLING) instead of LEVEL_LOW. These changes are important for my theory to work correctly. The only remaining trap at this point would be in the chip, which says it cannot catch edges that happen too quickly, but the minimum length of the edges it detects is sufficiently small not to be of anyone's concern.

> I hope my explanation was clear enough this time. As I said, we may put some
> warnings in the documentation of the driver.
> 
> Best regards,
> 
> -- 
> David Jander

Thanks for your participation and work on this driver! ;)
/jfd

