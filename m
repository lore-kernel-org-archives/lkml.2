Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab0LNIac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 03:30:32 -0500
Received: from web31813.mail.mud.yahoo.com ([68.142.207.76]:42162 "HELO
	web31813.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750759Ab0LNIab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 03:30:31 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=lV//RQAvnPOmMkGq69KbPXyTvC2jQsjUoBp3ILKa5Fvk98UCm09dcnqu0TJvJ/dmxb53ErSyCgFtYj9h+rjO/U451PBGFn4vQu1sgQodMZev+EwpdCqbNl3dDnyUu+TZgBjfa2pGTxd3pbcQ6s8m5Ed90h+CalDWPDxQogGWpJ4=;
Message-ID: <974005.13125.qm@web31813.mail.mud.yahoo.com>
X-YMail-OSG: tnELA2cVM1mb5KcsGLHRvKn1Y_gQ46uC.O8Q7PVwjuirHAE
 szVQzfU0sFSxkhosbRf_t4mT6egcZFOKsVbKtTcaY4lKMH.7tx.265gkGcO7
 Of.SKKverkEsCfCtuxr7L7FfUTiugZzzTFsXhqJYXz9EgvM9YJocopdB.yCa
 PJoGpd2TzgfqJuhu_pkAu3wkR.Uw8Bh24JyraIZM7RwRJajVqIDOCNAS7iM5
 gSfaFLb3SodKEl_RGa7OMX5Tj38tu20Zs4FC0OVnx4NaXcXVoAtO8FpTI5RQ
 EXii4YbejFLZX4jaFi762AmxUYtKb0F1x26HUIN_iBVna8lvm4UcKkC099LF
 JsEkoItq7iLiMXygKxbHSm27.6.NXBm0HhlTM6Cu47MjcYJOro3t2x.fBqD.
 8UiZtCSuWvac-
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.289296
Date: Tue, 14 Dec 2010 00:30:29 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH] [USB] UASP: USB Attached SCSI (UAS) protocol driver
To: Andreas Mohr <andi@lisas.de>, Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Mark Brown <broonie@sirena.org.uk>, Matthias Schniedermeyer <ms@citd.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <20101214004208.GA25538@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Mon, 12/13/10, Sarah Sharp <sarah.a.sharp@linux.intel.com> wrote:
> I think you may be missing some code review on the
> linux-usb mailing
> list.

There was never a review of uasp.c. Let's be clear on that. Because the way you've written the above sentence, someone may misread it to understand that your co-workers and Greg had written extensive review of uasp and had rejected it based on some tangible virtue. Greg's NAK came 4 minutes after I posted it and I mentioned that in my response (in this thread).

> Luben posted his original patch to the uas.c
> driver there, but he
> included behavior changes, code style modification, and
> variable
> renaming in one giant patch.

I wanted to rip the whole thing out. That patch changed a modest 86% of the code and I did mention that in the patch:
http://marc.info/?l=linux-usb&m=128901883420388&w=2

> It was very difficult to
> wade through,

That's why it's better to rip the whole thing out and put in something properly done.

> so
> I asked him to break the changes into a series of patches
> (perhaps 18,
> since he has 18 points?).

I'm not going to generate 18+ patches that changes 100% of that driver into a completely different and working driver.

First, I've no time for this. Second, it's much better, quicker and error-proof to present a whole _new_ piece (and show how it's done), moreover the fact that there are no UAS devices out there at the moment.

You and anyone else can certainly contribute to uasp.c. What's the point in converting the defunct uas.c to look like the working uasp.c (two different drivers)? The proper thing is to pull uas.c out and put uasp.c in (working and properly implemented (see my original editorial and patches to uas.c)).

> I did attempt to give a partial code review of Luben's
> original patches,
> and he has yet to respond to any of my points:
> 
> http://marc.info/?l=linux-kernel&m=129021816023869&w=2

Now that you asked, I just did respond to this. The reason I didn't respond to it before is because I didn't think there was any point in responding then, as I do now.  Back then I would've said: the whole thing should be ripped out and re-written. Now I'd say: refer to uasp.c on how it's done.  It's available on github.

> I also asked him to change a different patch for his
> driver, to move a
> work-around into a better place:
> 
> http://marc.info/?l=linux-kernel&m=129192831709856&w=2

And I responded to this in the next entry in the thread in the same link. The parameter still has value. Most likely it wouldn't have to be set (but it still has value in the very very rare case...).

> I have yet to see an updated patch set, only personal
> attacks.

A patch set for what? UAS? See uasp.c on how it's done. For the host that mis-calculates the number of streams it reports in HCCPARAMS? I still haven't had time to plug in a newer version of this HC. When I do and if it still misbehaves, I'll send you a dump of the PCI config space and you can decide what you want to do.

   Luben


