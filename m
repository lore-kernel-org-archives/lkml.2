Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009Ab1ANOIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 09:08:20 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61619 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab1ANOIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 09:08:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=v33L8BbGwQ+ysfA6Lm/ub+uU+UZPyY6Ife0ivC6FXcObqEHviQKNACfcRVndc8NxRB
         17OL71Wqb2fy7Gnv2nP2RJCgSgB01p5hf2v2qziD8yOMonNJ0qg1Q1DXvKPJTbDqWEm1
         hutkRDuf5iPy1FlrigTqe3KR6U5WRMila/SXk=
Date: Fri, 14 Jan 2011 16:08:03 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: BUG: spinlock bad magic on CPU#0
Message-ID: <20110114140803.GA4003@swordfish>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

Acer Aspire  5741g
2.6.37-git11

Got this trace today:

[    0.814609] ACPI: EC: Look up EC in DSDT
[    0.825556] BUG: spinlock bad magic on CPU#0, swapper/1
[    0.825639]  lock: ffffffff8242fa90, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
[    0.825741] Pid: 1, comm: swapper Not tainted 2.6.37-dbg-git11-07456-gdbc61c6-dirty #359
[    0.825841] Call Trace:
[    0.825923]  [<ffffffff81247919>] ? spin_bug+0x9c/0xa3
[    0.826004]  [<ffffffff812479e9>] ? do_raw_spin_lock+0x29/0x122
[    0.826093]  [<ffffffff814867e5>] ? _raw_spin_lock_irqsave+0x56/0x60
[    0.826181]  [<ffffffff81275e8a>] ? acpi_os_acquire_lock+0x9/0xb
[    0.826264]  [<ffffffff81275e8a>] ? acpi_os_acquire_lock+0x9/0xb
[    0.826350]  [<ffffffff81288fad>] ? acpi_ev_acquire_global_lock+0x10b/0x206
[    0.826438]  [<ffffffff8129620c>] ? acpi_ex_acquire_mutex_object+0xa3/0x11d
[    0.826525]  [<ffffffff812952e3>] ? acpi_ex_acquire_global_lock+0x61/0xa2
[    0.826613]  [<ffffffff8128def7>] ? acpi_ex_read_data_from_field+0x293/0x2f1
[    0.826701]  [<ffffffff81296e88>] ? acpi_ex_resolve_node_to_value+0x320/0x444
[    0.826789]  [<ffffffff812a8587>] ? acpi_ut_trace_ptr+0x58/0x65
[    0.826874]  [<ffffffff8128efb1>] ? acpi_ex_resolve_to_value+0x379/0x406
[    0.826961]  [<ffffffff81284efb>] ? acpi_ds_evaluate_name_path+0x9e/0x143
[    0.827048]  [<ffffffff812824c5>] ? acpi_ds_exec_end_op+0xda/0x641
[    0.827131]  [<ffffffff812a844c>] ? acpi_ut_status_exit+0x6f/0x80
[    0.827216]  [<ffffffff812a2e5c>] ? acpi_ps_parse_loop+0xc65/0xf45
[    0.827302]  [<ffffffff812a1acf>] ? acpi_ps_parse_aml+0x162/0x467
[    0.827385]  [<ffffffff812a8691>] ? acpi_ut_ptr_exit+0x33/0x3b
[    0.827470]  [<ffffffff812a3b5a>] ? acpi_ps_execute_method+0x26d/0x393
[    0.827558]  [<ffffffff8129c14d>] ? acpi_ns_evaluate+0x235/0x3b7
[    0.827643]  [<ffffffff812ab605>] ? acpi_ut_add_reference+0xb1/0xb8
[    0.827730]  [<ffffffff8129c42a>] ? acpi_ns_exec_module_code_list+0x15b/0x25d
[    0.827818]  [<ffffffff812a9dbb>] ? acpi_initialize_objects+0x88/0x17d
[    0.827907]  [<ffffffff81ad43ff>] ? acpi_init+0x0/0x10a
[    0.827990]  [<ffffffff81ad42c1>] ? acpi_bus_init+0x9f/0x1dd
[    0.828076]  [<ffffffff8123c24b>] ? kobject_create_and_add+0x37/0x68
[    0.828162]  [<ffffffff81ad4470>] ? acpi_init+0x71/0x10a
[    0.828248]  [<ffffffff810002ee>] ? do_one_initcall+0x7a/0x13c
[    0.828334]  [<ffffffff81aacda0>] ? kernel_init+0x16c/0x1f0
[    0.828420]  [<ffffffff81002fa4>] ? kernel_thread_helper+0x4/0x10
[    0.828506]  [<ffffffff81031ab3>] ? finish_task_switch+0x78/0xec
[    0.828592]  [<ffffffff81487318>] ? restore_args+0x0/0x30
[    0.828677]  [<ffffffff81aacc34>] ? kernel_init+0x0/0x1f0
[    0.828760]  [<ffffffff81002fa0>] ? kernel_thread_helper+0x0/0x10
[    0.828935] ACPI: Executed 1 blocks of module-level executable AML code


	Sergey

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAk0wWMMACgkQfKHnntdSXjRxWQQApPteYOSyA3I/SFKAxWHncqvG
SnxmXVpCjUjUDQ5X9WtpHmuBFshf2b6papfCX05QSNGz5YFe0BKxZLujnoj16otR
MnYohuL48hQOh5OFyLA11oyBRTGP2n2MMahttXFnJ2UkoaowUQEFh9us5v8GXZh1
pv+GVkO+424Kj8LWbnA=
=Rp1d
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
