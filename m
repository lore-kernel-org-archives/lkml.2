Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab1IYSkP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 14:40:15 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45041 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab1IYSkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 14:40:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo6xBT=WD44sw28cxUf=DeFgAw7i=FZqBG-OR68V6NbqAg@mail.gmail.com>
References: <CAK82gMF0EbPiTATjPZ2-K5fCtuJHAXH2aJgpwCD5CRDLS2YpqQ@mail.gmail.com>
	<20110925002831.GA32152@elie>
	<CAErSpo6xBT=WD44sw28cxUf=DeFgAw7i=FZqBG-OR68V6NbqAg@mail.gmail.com>
Date: Sun, 25 Sep 2011 14:40:13 -0400
Message-ID: <CAK82gMFhcKiqcFdaJTTOXZEmXJd2FUtCnm5S5ewXiNO=Xs8VQA@mail.gmail.com>
Subject: Re: Possible PNP issue on Dell PowerEdge 4200 unless noapic used
From: trouble daemon <troubledaemon@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>, Adam Belay <abelay@mit.edu>,
        linux-kernel@vger.kernel.org, 586494@bugs.debian.org
Content-Type: multipart/mixed; boundary=00151773e0e472dc1b04adc85f56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00151773e0e472dc1b04adc85f56
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Heya,

On Sun, Sep 25, 2011 at 8:24 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> [Resending since gmail made it HTML, which LKML thinks is spam. =A0sigh]
>
> On Sat, Sep 24, 2011 at 6:28 PM, Jonathan Nieder <jrnieder@gmail.com> wro=
te:
>>
>> (just cc-ing linux-kernel so any work on this gets archived)
>> trouble daemon wrote:
>>
>> > Greetings,
>> >
>> > Hello Adam and Bjorn. I am sending this email to you as suggested by
>> > Jonathan regarding a problem that I was having with Linux on a pair of
>> > old Dell PowerEdge 4200 machines that I own (yes, they still run!).
>> >
>> > I have left the most recent reply between Jonathan and I quoted below,
>> > but you can find the original bug report at the Debian bug tracker
>> > under bug #586494 [1]. As a brief recap, I have been required to use
>> > the noapic kernel option in these systems in order to allow them to
>> > boot, and appears to have originated after a commit to the kernel
>> > relating to EISA (although it has come to my attention now that PNP
>> > may be related as well).
>> >
>> > As suggested, I have attached a copy of the "quick & dirty" config I
>> > used for a vanilla 3.1.0-rc7 kernel I compiled, along with the boot
>> > log of the machine, and a diff against the apic log of a working boot
>> > of the same kernel when using noapic. One thing that I should mention
>> > is that on these dells, I also usually use the pnpbios=3Doff option to
>> > hide the pesky warnings on boot, in addition to noapic.
>> >
>> > I hope these logs help you in some way. If there is anything else you
>> > might be interested in knowing or testing, don't hesitate to ask!
>>
>> Original report: http://thread.gmane.org/gmane.linux.kernel/1000807
>> Logs: http://bugs.debian.org/cgi-bin/bugreport.cgi?msg=3D86;bug=3D586494
>>
>> > Dan McGrath
>> >
>> > PS - Not a problem Jonathan, thanks!
>> >
>> > [1] http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D586494


> Dan, can you try the attached patch? =A0I'm not an MPS expert, but from
> inspecting f8924e770, it seems suspect that we used to always set the
> mp_bus_not_pci bit, then clear it if we found a PCI bus. =A0After
> f8924e770, we set mp_bus_not_pci for ISA buses, clear it for PCI
> buses, and leave it alone otherwise.

Success! :) Booted up like a charm in 3.1.0-rc7 with the patch applied
and no kernel boot params.

Thank you for figuring it out *bow*

--00151773e0e472dc1b04adc85f56
Content-Type: application/octet-stream; name=mps-fix
Content-Disposition: attachment; filename=mps-fix
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gt0038me0

Y29tbWl0IDdlZDFjMWY0NGJjNThkOWU2YTAxZDdlOTcwYThhZDI1ZWNlM2RmMDYKQXV0aG9yOiBC
am9ybiBIZWxnYWFzIDxiaGVsZ2Fhc0Bnb29nbGUuY29tPgpEYXRlOiAgIFN1biBTZXAgMjUgMDY6
MDk6MzEgMjAxMSAtMDYwMAoKZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9tcHBhcnNlLmMg
Yi9hcmNoL3g4Ni9rZXJuZWwvbXBwYXJzZS5jCmluZGV4IDkxMDNiODkuLjA3NDFiMDYyIDEwMDY0
NAotLS0gYS9hcmNoL3g4Ni9rZXJuZWwvbXBwYXJzZS5jCisrKyBiL2FyY2gveDg2L2tlcm5lbC9t
cHBhcnNlLmMKQEAgLTk1LDggKzk1LDggQEAgc3RhdGljIHZvaWQgX19pbml0IE1QX2J1c19pbmZv
KHN0cnVjdCBtcGNfYnVzICptKQogCX0KICNlbmRpZgogCisJc2V0X2JpdChtLT5idXNpZCwgbXBf
YnVzX25vdF9wY2kpOwogCWlmIChzdHJuY21wKHN0ciwgQlVTVFlQRV9JU0EsIHNpemVvZihCVVNU
WVBFX0lTQSkgLSAxKSA9PSAwKSB7Ci0JCXNldF9iaXQobS0+YnVzaWQsIG1wX2J1c19ub3RfcGNp
KTsKICNpZiBkZWZpbmVkKENPTkZJR19FSVNBKSB8fCBkZWZpbmVkKENPTkZJR19NQ0EpCiAJCW1w
X2J1c19pZF90b190eXBlW20tPmJ1c2lkXSA9IE1QX0JVU19JU0E7CiAjZW5kaWYK
--00151773e0e472dc1b04adc85f56--
