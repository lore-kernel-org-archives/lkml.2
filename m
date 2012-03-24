Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab2CXB0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 21:26:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60306 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203Ab2CXB0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 21:26:37 -0400
From: Thomas Renninger <trenn@suse.de>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] ACPI: Implement overriding of arbitrary ACPI tables via initrd
Date: Sat, 24 Mar 2012 02:26:34 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34.10-0.4-desktop; KDE/4.4.4; x86_64; ; )
Cc: eric.piel@tremplin-utc.net, vojcek@tlen.pl, dsdt@gaugusch.at,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, Lin Ming <ming.m.lin@intel.com>, lenb@kernel.org,
        robert.moore@intel.com, hpa@zytor.com
References: <1332512984-79664-1-git-send-email-trenn@suse.de> <CAE9FiQVFd=Zef2bH_3MinLEV_V+cEShrmRTe7Sr8HT2R46yHHw@mail.gmail.com>
In-Reply-To: <CAE9FiQVFd=Zef2bH_3MinLEV_V+cEShrmRTe7Sr8HT2R46yHHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203240226.35314.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 March 2012 21:54:12 Yinghai Lu wrote:
> On Fri, Mar 23, 2012 at 7:29 AM, Thomas Renninger <trenn@suse.de> wrote:
...
 
> great. that is very good feature for development and debug.
Thanks.
...

> > +       int table_nr = 0;
> > +       *table_length = 0;
> > +       *address = 0;
> > +       for (; table_nr < ACPI_OVERRIDE_TABLES &&
> > +                    acpi_table_override_offset[table_nr]; table_nr++) {
> > +               int table_offset;
> > +               int table_len;
> > +               struct acpi_table_header *table;
> > +
> > +               if (table_nr == 0)
> > +                       table_offset = 0;
> > +               else
> > +                       table_offset = acpi_table_override_offset[table_nr - 1];
> >
> > +               table_len = acpi_table_override_offset[table_nr] - table_offset;
> > +
> > +               table = acpi_os_map_memory(acpi_tables_inram + table_offset,
> > +                                          table_len);
> > +
> 
> maybe could have dmi checking for more strict checking.
I do not understand what should get checked?
Hm, I guess you mean if a general table is always added that is distributed
on different platforms and you want to white/blacklist machines to
explicitly load/not load the table?
This must not happen.
The tables are always platform specific and you provide tables for
a specific machine only for debugging purposes.

> also would help if have one boot command that could skip overriding.
Same. Both should not be needed.

Or you have a use-case in mind I cannot not think of...

   Thomas
