Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab1EAHXj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 03:23:39 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:32973 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752122Ab1EAHXj (ORCPT
	<rfc822;groupwise-jlee@novell.com:5:1>);
	Sun, 1 May 2011 03:23:39 -0400
Message-Id: <4DBD9716020000230002C094@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Sun, 01 May 2011 01:23:34 -0600
From: "Joey Lee" <jlee@novell.com>
To: <melchior.franz@gmail.com>
Cc: "Joey Lee" <JLee@novell.com>, <carlos@strangeworlds.co.uk>,
        <tiwai@suse.de>, <linux-kernel@vger.kernel.org>
Subject: Re: acer_wmi: "Unable to detect available WMID devices" on
 Acer_Travelmate_5735Z-452G32Mnss (was: Re: i915/kms/backlight-combo
 mode problem)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 六，2011-04-30 於 19:51 +0200，Melchior FRANZ 提到：
> Hey,
> 
> * Joey Lee -- Saturday 30 April 2011:
> > 於 六，2011-04-30 於 13:34 +0200，Melchior FRANZ 提到：
> > > * Takashi Iwai -- Saturday 30 April 2011:
> > > * * At Sat, 30 Apr 2011 10:32:04 +0200, Melchior FRANZ wrote:
> > > > > Yes, backlight adjustment generally works on this notebook, but only
> > > > > with "acpi_osi=Linux" on the command line.
> > > > 
> > > > acpi_osi quirk should be better added statically, then.
> > > 
> > > No, I guess the problem here is that acer_wmi doesn't support this
> > > machine yet.
> 
> > Could you please attach DSDT on this mail or share your kernel bugzilla
> > number to us?
> 
> I've just created the bugzilla entry: #34142. There you find the output of
> dmesg, of acpidump and the DSDT.
> 
> 
> Here's in addition a table with the info of debug_dump_wdg=1. The last
> column shows if an ID is already #defined or used as module alias.
> 
>                                         obj_id  not_id  res     flags
> F6CB5C3C-9CAE-4EBD-B577-931EA32A2CC0:   MX      4D      58      0x2 ACPI_WMI_METHOD     -
> F28A9357-CF4B-4A1A-8893-BB1F58EEA1AF:   Ñ       D1      00      0x8 ACPI_WMI_EVENT      -
> 05901221-D566-11D1-B2F0-00A0C9062910:   XM      58      4D      0x0                     -
> 95764E09-FB56-4E83-B31A-37761F60994A:   AA      41      41      0x1 ACPI_WMI_EXPENSIVE  WMID_GUID2
> 6AF4F258-B401-42FD-BE91-3D4AC2D7C0D3:   BA      42      41      0x2 ACPI_WMI_METHOD     WMID_GUID1, MODULE_ALIAS
> CC1A61AC-4256-41A3-B9E0-05A445ADE2F5:   0x80    80      00      0x8 ACPI_WMI_EVENT      -
> E78C4453-0227-4861-9EDE-F5600B4A3D39:   BB      42      42      0x2 ACPI_WMI_METHOD     -
> AAE04F7B-B3C5-4865-95D6-9FAC7FF3E92B:   BC      42      43      0x2 ACPI_WMI_METHOD     -
> CFF94C79-6C77-4AF7-AC56-7DD0CE01C997:   BD      42      44      0x2 ACPI_WMI_METHOD     -
> 79772EC5-04B1-4BFD-843C-61E7F77B6CC9:   BE      42      45      0x2 ACPI_WMI_METHOD     -
> A7C9A0B7-4C9D-4C72-83BB-53A3459171DF:   BF      42      46      0x2 ACPI_WMI_METHOD     -
> 653A064F-A23A-485F-B3D9-13F6532A0182:   BG      42      47      0x2 ACPI_WMI_METHOD     -
> 5923DD45-0480-4ED5-B61A-C9EC6C90E26A:   BH      42      48      0x2 ACPI_WMI_METHOD     -
> DB85B1A7-069A-4ABB-A2B5-D186A21B80F1:   0x81    81      00      0x8 ACPI_WMI_EVENT      -
> 36916B91-1A64-4583-84D0-53830FB9108D:   0x82    82      00      0x8 ACPI_WMI_EVENT      -
> 676AA15E-6A47-4D9F-A2CC-1E6D18D14026:   ¼       BC      00      0x8 ACPI_WMI_EVENT      ACERWMID_EVENT_GUID, MODULE_ALIAS
> 61EF69EA-865C-4BC3-A502-A0DEBA0CB531:   AA      41      41      0x2 ACPI_WMI_METHOD     WMID_GUID3
> 05901221-D566-11D1-B2F0-00A0C9062910:   AB      41      42      0x0			-
> FAAA1397-1188-448F-8516-9A07987DD38A:   BI      42      49      0x2 ACPI_WMI_METHOD	-
> 
> m.

Thank's for your DSDT, I just added comment on bugzilla.
This machine support newest WMID GUID3 method but the old WMID_GUID2
method must be also work. 

I am tracing DSDT for why the WMID2 method return acpi fail, and maybe
this machine direct support standard ACPI backlight method.

Sorry for I didn't follow up this mail loop and maybe lose some
information.
Does this machine's backlight control works before 2.6.39 kernel? I mean
does backlight control works fine on 2.6.38 or 37 or even older kernel ?


Thank's a lot!
Joey Lee

