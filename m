Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab2LMPPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:15:42 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:33480 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587Ab2LMPPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 10:15:40 -0500
Message-ID: <50C9F114.4050502@ti.com>
Date: Thu, 13 Dec 2012 10:15:32 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: "Kumar, Anil" <anilkumar.v@ti.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: linux-next: manual merge of the l2-mtd tree with Linus' tree
References: <20121213123755.db3d38128e0593a372ccf17f@canb.auug.org.au> <F3DBB1B3EF102E4994C89758CFCA32412A304D@DBDE01.ent.ti.com>
In-Reply-To: <F3DBB1B3EF102E4994C89758CFCA32412A304D@DBDE01.ent.ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2012 12:38 AM, Kumar, Anil wrote:
> On Thu, Dec 13, 2012 at 07:07:55, Stephen Rothwell wrote:
>> Hi Artem,
>>
>> Today's linux-next merge of the l2-mtd tree got a conflict in
>> Documentation/devicetree/bindings/arm/davinci/nand.txt between commit
>> fed16bba8726 ("mtd: nand: davinci: fix the binding documentation") from
>> Linus' tree and commit 192afdbfbc5c ("mtd: davinci: add support for
>> parition binding nodes") from the l2-mtd tree.
>>
>> I fixed it up (maybe- see below) and can carry the fix as necessary (no
>> action is required).
>>
>> -- 
>> Cheers,
>> Stephen Rothwell                    sfr@canb.auug.org.au
>>
>> diff --cc Documentation/devicetree/bindings/arm/davinci/nand.txt
>> index 49fc7ad,4746452..0000000
>> --- a/Documentation/devicetree/bindings/arm/davinci/nand.txt
>> +++ b/Documentation/devicetree/bindings/arm/davinci/nand.txt
>> @@@ -23,16 -23,37 +23,24 @@@ Recommended properties
>>    - ti,davinci-nand-buswidth: buswidth 8 or 16
>>    - ti,davinci-nand-use-bbt: use flash based bad block table support.
>>
>> + nand device bindings may contain additional sub-nodes describing
>> + partitions of the address space. See partition.txt for more detail.
>> +
>>   -Example (enbw_cmc board):
>>   -aemif@60000000 {
>>   -	compatible = "ti,davinci-aemif";
>>   -	#address-cells =<2>;
>>   -	#size-cells =<1>;
>>   -	reg =<0x68000000 0x80000>;
>>   -	ranges =<2 0 0x60000000 0x02000000
>>   -		  3 0 0x62000000 0x02000000
>>   -		  4 0 0x64000000 0x02000000
>>   -		  5 0 0x66000000 0x02000000
>>   -		  6 0 0x68000000 0x02000000>;
>>   -	nand@3,0 {
>>   -		compatible = "ti,davinci-nand";
>>   -		reg =<3 0x0 0x807ff
>>   -			6 0x0 0x8000>;
>>   -		#address-cells =<1>;
>>   -		#size-cells =<1>;
>>   -		ti,davinci-chipselect =<1>;
>>   -		ti,davinci-mask-ale =<0>;
>>   -		ti,davinci-mask-cle =<0>;
>>   -		ti,davinci-mask-chipsel =<0>;
>>   -		ti,davinci-ecc-mode = "hw";
>>   -		ti,davinci-ecc-bits =<4>;
>>   -		ti,davinci-nand-use-bbt;
>>   +Example(da850 EVM ):
>>   +nand_cs3@62000000 {
>>   +	compatible = "ti,davinci-nand";
>>   +	reg =<0x62000000 0x807ff
>>   +		0x68000000 0x8000>;
>>   +	ti,davinci-chipselect =<1>;
>>   +	ti,davinci-mask-ale =<0>;
>>   +	ti,davinci-mask-cle =<0>;
>>   +	ti,davinci-mask-chipsel =<0>;
>>   +	ti,davinci-ecc-mode = "hw";
>>   +	ti,davinci-ecc-bits =<4>;
>>   +	ti,davinci-nand-use-bbt;
>> +
>>   -		partition@180000 {
>>   -			label = "ubifs";
>>   -			reg =<0x180000 0x7e80000>;
>>   -		};
>> ++	partition@180000 {
>> ++		label = "ubifs";
>> ++		reg =<0x180000 0x7e80000>;
> partition@180000 is sub-node of nand_cs3@62000000.
> nand_cs3@62000000 needs to use below properties
>
> #address-cells =<1>;
> #size-cells =<1>;
>
> Without these properties DT build will give reg format Warning.
>
>> + 	};
>>    };
>>
Anul,

Could you point me to a corresponding driver commit id?

Murali
