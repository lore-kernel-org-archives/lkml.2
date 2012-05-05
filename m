Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab2EEP16 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 11:27:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33551 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951Ab2EEP14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 11:27:56 -0400
Message-ID: <4FA546F1.1020008@gmail.com>
Date: Sat, 05 May 2012 23:27:45 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Francois Rigaut <frigaut@gmail.com>
CC: Yinghai Lu <yinghai@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org,
        Nico Schottelius <nico-linux-20120419@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux Support for Thunderbolt using Apple Monitor
References: <20120419163800.GB13977@schottelius.org> <CAMVeQ8r_3vuAxzbLyKoecOHOOGijUDkLfw+MK7o-WoWbuOGSrg@mail.gmail.com> <20120502163629.GE928@schottelius.org> <20120502202509.GA26798@kroah.com> <20120503065003.GB13386@schottelius.org> <CAMVeQ8qYu4bShd_+pwRv8bShhusJMDa-jjoqu7EujS4jt7RSNA@mail.gmail.com> <20120503153547.GD20334@kroah.com> <CAMVeQ8q3PMMGmFSgrnqbW2HVdfmN+LgatX3TSfv5_2Ebuuj=QQ@mail.gmail.com> <20120503233858.GA13453@kroah.com> <4FA358ED.1080705@gmail.com> <20120504184851.GB11223@kroah.com> <CAE9FiQWuePNRWV=ncJkF57aQZ0ZT91xxZ0sZMexq8HgN9NcAfA@mail.gmail.com> <CAE9FiQWcyRfLKB+YivOfa-GydbhoaMx06n6a4VMDWoTOMkj7ig@mail.gmail.com> <4FA4AA3E.1070903@gmail.com> <4FA4E259.9070903@gmail.com> <4FA4E93F.3050800@gmail.com>
In-Reply-To: <4FA4E93F.3050800@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's another mysterious _DSM function under \_SB.PCI0.P0P2.UPSB.
Seems it's related to Thunderbolt technology.

                    Method (_DSM, 4, NotSerialized)
                    {
                        If (LEqual (Arg0, Buffer (0x10)
                                {
                                    /* 0000 */    0xC6, 0xB7, 0xB5, 0xA0, 0x18, 0x13, 0x1C, 0x44,
                                    /* 0008 */    0xB0, 0xC9, 0xFE, 0x69, 0x5E, 0xAF, 0x94, 0x9B
                                }))
                        {
                            Store (Package (0x02)
                                {
                                    "PCI-Thunderbolt",
                                    0x01
                                }, Local0)
                            DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                            Return (Local0)
                        }

                        Return (0x80000002)
                    }


On 05/05/2012 04:47 PM, Francois Rigaut wrote:
> http://maumae.net/thunderbolt/acpidump.bin
> Thanks.
> Francois
> 
> 
> On 05/05/12 18:18, Jiang Liu wrote:
>> This log message below implies that your BIOS doesn't provide the ACPI interfaces
>> needed by acpiphp driver. Maybe an ACPI dump file may help to identify the issue.
>> You may generate acpidump file by:
>> acpidump>  acpidump.bin
>>
>>> May  5 14:09:55 localhost kernel: [28329.702720] acpiphp_glue: Total 0 slots
>> On 05/05/2012 12:19 PM, Francois Rigaut wrote:
>>> May  5 14:09:55 localhost kernel: [28329.702720] acpiphp_glue: Total 0 slots

