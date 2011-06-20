Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648Ab1FTKGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 06:06:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41290 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab1FTKGy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 06:06:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xdOrnVMdIADLg/WDnFRwsgyEeX7DxueStG2OWrZHc/76R+x9IUuisuvdigzXPoFZLv
         g29CdSMwrv4zdYi8vRQaaibo8e2lEuLv46VCzxlKPlKytkdVhk7QFz2PjTpyEsDyWEQg
         kGa1tPE9vQRmep/qgRx/MCr7YsiC3wEZxZ+Y4=
MIME-Version: 1.0
In-Reply-To: <20110620081937.GN2611@htj.dyndns.org>
References: <20110617120704.GH2611@htj.dyndns.org>
	<1308557202-1895-1-git-send-email-yuanlmm@gmail.com>
	<20110620081937.GN2611@htj.dyndns.org>
Date: Mon, 20 Jun 2011 18:06:52 +0800
Message-ID: <BANLkTi=dgTNUESCstJNFUg6_YLbfwpNF5g@mail.gmail.com>
Subject: Re: [PATCH v4] ahci: move ahci_sb600_softreset to libahci.c and
 rename it
From: Yuan-Hsin Chen <yuanlmm@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        sshtylyov@mvista.com, Yuan-Hsin Chen <yhchen@faraday-tech.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On Mon, Jun 20, 2011 at 4:19 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Yuan.
>
> Yeap, almost there, just few very minor things. :)
>
> On Mon, Jun 20, 2011 at 04:06:41PM +0800, Yuan-Hsin Chen wrote:
>>  static struct ata_port_operations ahci_sb600_ops = {
>>       .inherits               = &ahci_ops,
>> -     .softreset              = ahci_sb600_softreset,
>> -     .pmp_softreset          = ahci_sb600_softreset,
>> +     .softreset              = ahci_pmp_retry_srst_softreset,
>>  };
>
> Why doesn't sb600 just use ahci_pmp_retry_srst_ops?
>
>> @@ -312,6 +312,7 @@ extern struct device_attribute *ahci_sdev_attrs[];
>>       .sdev_attrs             = ahci_sdev_attrs
>>
>>  extern struct ata_port_operations ahci_ops;
>> +extern struct ata_port_operations ahci_pmp_retry_srst_ops;
>
> Heh, I know I suggested that name but that is one ugly name.  If
> anyone has any better idea, please come forward.

How about ahci_pmp_workaround_softreset or ahci_pmp_ipms_set_softreset?
Also applys to ops, ahci_pmp_workaround_ops or ahci_pmp_ipms_set_ops.

>
>> @@ -82,6 +82,8 @@ static void ahci_pmp_attach(struct ata_port *ap);
>>  static void ahci_pmp_detach(struct ata_port *ap);
>>  static int ahci_softreset(struct ata_link *link, unsigned int *class,
>>                         unsigned long deadline);
>> +static int ahci_pmp_retry_srst_softreset(struct ata_link *link, unsigned int *class,
>> +                       unsigned long deadline);
>
> srst equals softreset, so ahci_pmp_retry_softreset() should do.
>
>> +struct ata_port_operations ahci_pmp_retry_srst_ops = {
>> +     .inherits               = &ahci_ops,
>> +     .softreset              = ahci_pmp_retry_srst_softreset,
>> +};
>> +EXPORT_SYMBOL_GPL(ahci_pmp_retry_srst_ops);
>> +
>>  struct ata_port_operations ahci_ops = {
>>       .inherits               = &sata_pmp_port_ops,
>
> Maybe it's better to place ahci_pmp_retry_srst_ops after ahci_ops?
>
>> +static int ahci_pmp_check_ready(struct ata_link *link)
>
> It would be better if the name reflects that it's not for specific
> workaround.
>
> Thank you.
>
> --
> tejun
>
