Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab2JCPP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 11:15:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932624Ab2JCPOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 11:14:02 -0400
Message-ID: <506C562E.5090909@redhat.com>
Date: Wed, 03 Oct 2012 12:13:50 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Greg KH <gregkh@linuxfoundation.org>, Kay Sievers <kay@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: udev breakages - was: Re: Need of an ".async_probe()" type of
 callback at driver's core - Was: Re: [PATCH] [media] drxk: change it to use
 request_firmware_nowait()
References: <1340285798-8322-1-git-send-email-mchehab@redhat.com> <4FE37194.30407@redhat.com> <4FE8B8BC.3020702@iki.fi> <4FE8C4C4.1050901@redhat.com> <4FE8CED5.104@redhat.com> <20120625223306.GA2764@kroah.com> <4FE9169D.5020300@redhat.com> <20121002100319.59146693@redhat.com> <CA+55aFyzXFNq7O+M9EmiRLJ=cDJziipf=BLM8GGAG70j_QTciQ@mail.gmail.com> <20121002221239.GA30990@kroah.com> <20121002222333.GA32207@kroah.com> <CA+55aFwNEm9fCE+U_c7XWT33gP8rxothHBkSsnDbBm8aXoB+nA@mail.gmail.com>
In-Reply-To: <CA+55aFwNEm9fCE+U_c7XWT33gP8rxothHBkSsnDbBm8aXoB+nA@mail.gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 02-10-2012 19:47, Linus Torvalds escreveu:
> On Tue, Oct 2, 2012 at 3:23 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>>
>> which went into udev release 187 which I think corresponds to the place
>> when people started having problems, right Mauro?
> 
> According to what I've seen, people started complaining in 182, not 187.

Yes. The issue was noticed with media drivers when people started using the
drivers on Fedora 17, witch came with udev-182. There's an open
bugzilla there:
	https://bugzilla.redhat.com/show_bug.cgi?id=827538

> See for example
> 
>   http://patchwork.linuxtv.org/patch/13085/
> 
> which is a thread where you were involved too..
> 
> See also the arch linux thread:
> 
>   https://bbs.archlinux.org/viewtopic.php?id=134012&p=1
> 
> And see this email from Kay Sievers that shows that it was all known
> about and intentional in the udev camp:
> 
>   http://www.spinics.net/lists/netdev/msg185742.html
> 
> There's a possible patch suggested here:
> 
>   http://lists.freedesktop.org/archives/systemd-devel/2012-August/006357.html
> 
> but quite frankly, I am leery of the fact that the udev maintenance
> seems to have gone into some "crazy mode" where they have made changes
> that were known to be problematic, and are pure and utter stupidity.
> 
> Having the module init path load the firmware IS THE SENSIBLE AND
> OBVIOUS THING TO DO for many cases. 

Yes, that is the case for most media devices. Some devices can only be
detected as a supported device after the firmware load, as we need the
firmware for the USB (or PCI) bridge to be there, in order to talk with
the media components under the board's internal I2C bus, as sometimes
the same USB/PCI ID is used by boards with different internal components.

> The fact that udev people have
> apparently unilaterally decided that it's somehow wrong is scary.
>

Thanks,
Mauro
