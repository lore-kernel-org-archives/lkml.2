Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab1EPCRQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 22:17:16 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:49556 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752382Ab1EPCRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 22:17:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Message-ID:In-Reply-To:References:Date:Subject:From:To:Cc:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:Importance:Return-Receipt-To:X-Identified-User;
	b=tQDzXW+rc5jexJlcUHLJne4ejxhKHIJ1ixnLLU/SEZf3vcMLXy2s5I27VkKiJXkBSx5ySt9t7IKzp/HFnSt0g6o8L4B0Y2D9S0YRNUR3f4eCqwpzuNG/aSXlrC7zsQgP;
Message-ID: <05c9d616f534239a619008acf9ce6089.squirrel@xenotime.net>
In-Reply-To: <9389EE59E16E9447AFB481039183BCF411AA99@039-SN1MPN1-005.039d.mgd.msft.net>
References: <20110511155211.GA21349@caffeine.csclub.uwaterloo.ca>
    <9389EE59E16E9447AFB481039183BCF4117B10@039-SN1MPN1-005.039d.mgd.msft.net>
    <20110512151113.GE21345@caffeine.csclub.uwaterloo.ca>
    <9389EE59E16E9447AFB481039183BCF411AA99@039-SN1MPN1-005.039d.mgd.msft.net>
Date: Sun, 15 May 2011 19:17:12 -0700
Subject: RE: spi_fsl_spi broken when compiled as module by
 b36ece832512c1a0afa54ff0a56d63492a1caf08
From: "Randy Dunlap" <rdunlap@xenotime.net>
To: "Hu Mingkai-B21284" <B21284@freescale.com>
Cc: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Grant Likely" <grant.likely@secretlab.ca>,
        "Kumar Gala" <galak@kernel.crashing.org>
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:program running on server}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 15, 2011 7:10 pm, Hu Mingkai-B21284 wrote:
> Hi len,
>
> You can prepare the patch using git tool and send it to the maillist.

Hi,

What do you mean by this?  In the past there has been no
requirement for individual patch submitters to use git
(whereas tree maintainers might be so required).

Are you implying that using git is required for some
kernel patches?

Thanks.


> Also add spi-devel-general@lists.sourceforge.net maillist.
>
> Thanks,
> Mingkai
>
>> -----Original Message-----
>> From: Lennart Sorensen [mailto:lsorense@csclub.uwaterloo.ca]
>> Sent: Thursday, May 12, 2011 11:11 PM
>> To: Hu Mingkai-B21284
>> Cc: Lennart Sorensen; linux-kernel@vger.kernel.org; Grant Likely; Kumar
>> Gala
>> Subject: Re: spi_fsl_spi broken when compiled as module by
>> b36ece832512c1a0afa54ff0a56d63492a1caf08
>>
>> On Thu, May 12, 2011 at 01:33:55AM +0000, Hu Mingkai-B21284 wrote:
>> > Please submit a patch to modify it.
>>
>> OK.  Here it is.
>>
>> --
>> Len Sorensen
>>
>> Add missing exports and module license to allow compiling of spi_fsl_*
>> drivers as modules again.  Originally broken by refactoring of code in
>> b36ece832512c1a0afa54ff0a56d63492a1caf08.
>>
>> diff --git a/drivers/spi/spi_fsl_lib.c b/drivers/spi/spi_fsl_lib.c index
>> ff59f42..d7efaac 100644
>> --- a/drivers/spi/spi_fsl_lib.c
>> +++ b/drivers/spi/spi_fsl_lib.c
>> @@ -48,16 +48,23 @@ u32 mpc8xxx_spi_tx_buf_##type(struct mpc8xxx_spi
>> *mpc8xxx_spi)	\
>>  }
>>
>>  MPC8XXX_SPI_RX_BUF(u8)
>> +EXPORT_SYMBOL(mpc8xxx_spi_rx_buf_u8);
>>  MPC8XXX_SPI_RX_BUF(u16)
>> +EXPORT_SYMBOL(mpc8xxx_spi_rx_buf_u16);
>>  MPC8XXX_SPI_RX_BUF(u32)
>> +EXPORT_SYMBOL(mpc8xxx_spi_rx_buf_u32);
>>  MPC8XXX_SPI_TX_BUF(u8)
>> +EXPORT_SYMBOL(mpc8xxx_spi_tx_buf_u8);
>>  MPC8XXX_SPI_TX_BUF(u16)
>> +EXPORT_SYMBOL(mpc8xxx_spi_tx_buf_u16);
>>  MPC8XXX_SPI_TX_BUF(u32)
>> +EXPORT_SYMBOL(mpc8xxx_spi_tx_buf_u32);
>>
>>  struct mpc8xxx_spi_probe_info *to_of_pinfo(struct fsl_spi_platform_data
>> *pdata)  {
>>  	return container_of(pdata, struct mpc8xxx_spi_probe_info, pdata);  }
>> +EXPORT_SYMBOL(to_of_pinfo);
>>
>>  void mpc8xxx_spi_work(struct work_struct *work)  { @@ -116,6 +123,7 @@
>> const char *mpc8xxx_spi_strmode(unsigned int flags)
>>  	}
>>  	return "CPU";
>>  }
>> +EXPORT_SYMBOL(mpc8xxx_spi_strmode);
>>
>>  int mpc8xxx_spi_probe(struct device *dev, struct resource *mem,
>>  			unsigned int irq)
>> @@ -168,6 +176,7 @@ int mpc8xxx_spi_probe(struct device *dev, struct
>> resource *mem,
>>  err:
>>  	return ret;
>>  }
>> +EXPORT_SYMBOL(mpc8xxx_spi_probe);
>>
>>  int __devexit mpc8xxx_spi_remove(struct device *dev)  { @@ -188,6
>> +197,7
>> @@ int __devexit mpc8xxx_spi_remove(struct device *dev)
>>
>>  	return 0;
>>  }
>> +EXPORT_SYMBOL(mpc8xxx_spi_remove);
>>
>>  int __devinit of_mpc8xxx_spi_probe(struct platform_device *ofdev)  { @@
>> -
>> 234,3 +244,8 @@ err:
>>  	kfree(pinfo);
>>  	return ret;
>>  }
>> +EXPORT_SYMBOL(of_mpc8xxx_spi_probe);
>> +
>> +MODULE_AUTHOR("Kumar Gala");
>> +MODULE_DESCRIPTION("Freescale SPI/eSPI controller driver library");
>> +MODULE_LICENSE("GPL");
>
>
> --


-- 
~Randy

