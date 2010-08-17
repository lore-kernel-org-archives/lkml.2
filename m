Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab0HQEoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 00:44:54 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50743 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab0HQEob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 00:44:31 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <4C6A139D.20507@np.css.fujitsu.com>
Date: Tue, 17 Aug 2010 13:44:13 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andi Kleen <andi@firstfloor.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        ACPI <linux-acpi@vger.kernel.org>, LKLM <linux-kernel@vger.kernel.org>,
        Lu Yinghai <yinghai@kernel.org>
Subject: Re: [PATCH 1/4] [Patch-next] ACPI, APEI, ERST Fix the wrong checking
 of Serialization Header's length
References: <4C69DDB5.6060103@np.css.fujitsu.com>	 <1282008836.2744.1490.camel@yhuang-dev>	 <4C69F094.1040607@np.css.fujitsu.com> <1282015344.2744.1500.camel@yhuang-dev>
In-Reply-To: <1282015344.2744.1500.camel@yhuang-dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/08/17 12:22), Huang Ying wrote:
> On Tue, 2010-08-17 at 10:14 +0800, Jin Dongming wrote:
>>> I don't think it is necessary to change the header definition, and
>>> seri_header is not a good name for me.
>> Why I added this structure here is that I don't want to do following checking.
>> For example,
>> 	if (header_length != 0x0c) {
>> 		...
>> 	}
> 
> This can be:
> 
>  static int erst_check_table(struct acpi_table_erst *erst_tab)
>  {
> -       if (erst_tab->header_length != sizeof(struct acpi_table_erst))
> +       if (erst_tab->header_length !=
> +           (sizeof(struct acpi_table_erst) - sizeof(erst_tab->header)))
> 
> like Yinghai has been done.
> 
Yes. It looks good. And I am sorry I am unaware of Yinghai' patch. 

> Best Regards,
> Huang Ying
> 
> 

Best Regards,
Jin Dongming

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


