Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab0DNJ5O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 05:57:14 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:49512 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748Ab0DNJ5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 05:57:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=NouNvW3m+Hvq1Ckv4//hoDO2DeN5qFj8b9Lrbo12VtA8Lc6/wBS1mhZyLt/cXeBkur
         AMa+iXf9yaVSSOo6mv7XbAkF3oqF9lGDJYqN8kH1JPNTn3ibaU2z2gTmkyEiv7iBZteh
         f61XNb2qLnOnx+IssQ47MLhdgpqCketduiPy0=
Date: Wed, 14 Apr 2010 12:57:51 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: Lin Ming <ming.m.lin@intel.com>, Bob Moore <robert.moore@intel.com>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [acpi:battery?] kernel oops on boot
Message-ID: <20100414095750.GA3304@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hello,
Kernel oops on early stages. The below trace is "copy-paste" from the paper
since syslog is not runing yet.

kernel: .34-rc4-git1 /* also tested on .34-rc4 .34-rc3-git10 */
laptop: ASUS f3jc x86


ds: 007b es:007b fs:00d8 gs:00e8 ss:0068
process: async/0
stack:
	0000000 c144c708 f66cdd20 c109fc0b f723c1b8 f71fcec0 f71aa208 00000020
	<0>	c11c4d40 00001000 000000b6 c12f61e0 c12f61bc f723c1b8 f71aa208
	f71fcec0
	<0>	f66cdd54 c11c4d58 00000020 f66cdd64 f73a0f84 f723c1b8 f70cdc70
	f66cdd74

call trace:
	__kmalloc+0xe1
	acpi_ex_read_data_from_field+0x156
	acpi_ex_read_data_from_field+0x16e
	acpi_ex_resolve_node_to_value
	acpi_ex_resolve_to_value
	acpi_ds_evaluate_name_path
	acpi_ds_exec_end_op
	acpi_ps_parse_loop
	trace_hardirqs_on
	acpi_ps_parse_aml
	acpi_ps_execute_method
	acpi_ns_eveluate
	acpi_evaluate_object
	acpi_battery_update
	acpi_battery_add
	acpi_device_probe
	driver_probe_device
	__driver_attach
	bus_for_each_dev
	driver_attach
	__driver_attach
	bus_add_driver
	driver_register
	trace_hardirqs_on_caller
	acpi_bus_register_driver
	acpi_battery_init_async
	async_thread
	default_wake_function
	async_thread
	kthread
	kthread
	kernel_thread_helper

code:
	fb 00 00 b8 0b 00 00 00 83 c4 14 e9 7a 01   00 00 31 c0 8b 7d d4 8b 4d dc 31 d2 f3 aa 6a 00
	0f b6 4b 1d 8b 43 10 8d 74 01 ff 89 f0 <f7> f1 31 d2 89 45 cc 0f b6 43 1c 8d 04 06 8d 75 ec
	f7 f1 31 d2

eip: <c11c66dd> acpi_ex_extract_from_field+0x5c/0x1c3 ss:esp 0068:f66cdcf8


	Sergey
--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkvFkZ4ACgkQfKHnntdSXjTTbQP/XescwxXhV7qhdMmdxuPOS5w2
DDP5tQDkx6qxf3xqHQja8Kd2fRV5Ue63cyyzJxwwWrGBf3RnZEH9QNRxGw2hNU/a
49p19Mis65t5mbmyN8vZKVOh8hbprdzhrXPPu2YVkhzSvEfQUuLVgrQSqbeZqxSH
a6PetG5rgvZOxXIJ5Kk=
=XaIo
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
