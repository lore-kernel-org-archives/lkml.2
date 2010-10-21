Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651Ab0JUUvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 16:51:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087Ab0JUUvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 16:51:17 -0400
Date: Thu, 21 Oct 2010 18:50:51 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH -tip  6/7] perf probe: Show accessible global variables
Message-ID: <20101021205051.GK3826@ghostprotocols.net>
References: <20101021101243.3542.28282.stgit@ltc236.sdl.hitachi.co.jp> <20101021101335.3542.31003.stgit@ltc236.sdl.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101021101335.3542.31003.stgit@ltc236.sdl.hitachi.co.jp>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Oct 21, 2010 at 07:13:35PM +0900, Masami Hiramatsu escreveu:
> Add --externs for allowing --vars to show accessible
> global(externally defined) variables from a given probe
> point too.
> This will give you a hint which globals can be accessible
> from the probe point.

Cool, but perhaps we need to filter out some of the globals? Things
like:

                long unsigned int       __kcrctab_tcp_hashinfo
                long unsigned int       __kcrctab_tcp_proc_register
                long unsigned int       __kcrctab_tcp_proc_unregister
                long unsigned int       __kcrctab_tcp_prot

If --verbose is specified we could then show everything.

So that it doesn't get this long:

[root@emilia ~]# perf probe -V tcp_v4_do_rcv:28 --externs
Available variables at tcp_v4_do_rcv:28
	@<tcp_v4_do_rcv+390>
		(function_type)*	ip_nat_decode_session
		(unknown_type)	__crc_ipv4_specific
		(unknown_type)	__crc_sysctl_tcp_low_latency
		(unknown_type)	__crc_tcp4_gro_complete
		(unknown_type)	__crc_tcp4_gro_receive
		(unknown_type)	__crc_tcp_hashinfo
		(unknown_type)	__crc_tcp_proc_register
		(unknown_type)	__crc_tcp_proc_unregister
		(unknown_type)	__crc_tcp_prot
		(unknown_type)	__crc_tcp_twsk_unique
		(unknown_type)	__crc_tcp_v4_conn_request
		(unknown_type)	__crc_tcp_v4_connect
		(unknown_type)	__crc_tcp_v4_destroy_sock
		(unknown_type)	__crc_tcp_v4_do_rcv
		(unknown_type)	__crc_tcp_v4_md5_do_add
		(unknown_type)	__crc_tcp_v4_md5_do_del
		(unknown_type)	__crc_tcp_v4_md5_hash_skb
		(unknown_type)	__crc_tcp_v4_md5_lookup
		(unknown_type)	__crc_tcp_v4_remember_stamp
		(unknown_type)	__crc_tcp_v4_send_check
		(unknown_type)	__crc_tcp_v4_syn_recv_sock
		__u8*	ip_tos2prio
		atomic_long_t*	vm_stat
		atomic_t	tcp_memory_allocated
		bool	c1e_detected
		char	__pcpu_scope_cpu_core_map
		char	__pcpu_scope_cpu_info
		char	__pcpu_scope_cpu_llc_id
		char	__pcpu_scope_cpu_number
		char	__pcpu_scope_cpu_sibling_map
		char	__pcpu_scope_current_task
		char	__pcpu_scope_init_tss
		char	__pcpu_scope_irq_count
		char	__pcpu_scope_irq_regs
		char	__pcpu_scope_irq_stack_ptr
		char	__pcpu_scope_irq_stack_union
		char	__pcpu_scope_irq_stat
		char	__pcpu_scope_kernel_stack
		char	__pcpu_scope_numa_node
		char	__pcpu_scope_orig_ist
		char	__pcpu_scope_process_counts
		char	__pcpu_scope_softirq_work_list
		char	__pcpu_scope_softnet_data
		char	__pcpu_scope_this_cpu_off
		char	__pcpu_scope_tick_cpu_device
		char	__pcpu_scope_vector_irq
		char	__pcpu_scope_vm_event_states
		char	__pcpu_scope_x2apic_extra_bits
		char	__pcpu_scope_x86_bios_cpu_apicid
		char	__pcpu_scope_x86_cpu_to_apicid
		char	__pcpu_scope_x86_cpu_to_node_map
		char*	__kstrtab_ipv4_specific
		char*	__kstrtab_sysctl_tcp_low_latency
		char*	__kstrtab_tcp4_gro_complete
		char*	__kstrtab_tcp4_gro_receive
		char*	__kstrtab_tcp_hashinfo
		char*	__kstrtab_tcp_proc_register
		char*	__kstrtab_tcp_proc_unregister
		char*	__kstrtab_tcp_prot
		char*	__kstrtab_tcp_twsk_unique
		char*	__kstrtab_tcp_v4_conn_request
		char*	__kstrtab_tcp_v4_connect
		char*	__kstrtab_tcp_v4_destroy_sock
		char*	__kstrtab_tcp_v4_do_rcv
		char*	__kstrtab_tcp_v4_md5_do_add
		char*	__kstrtab_tcp_v4_md5_do_del
		char*	__kstrtab_tcp_v4_md5_hash_skb
		char*	__kstrtab_tcp_v4_md5_lookup
		char*	__kstrtab_tcp_v4_remember_stamp
		char*	__kstrtab_tcp_v4_send_check
		char*	__kstrtab_tcp_v4_syn_recv_sock
		char*	hex_asc
		char*	inet_csk_timer_bug_msg
		cpumask_var_t	cpu_callout_mask
		cpumask_var_t	cpu_core_map
		cpumask_var_t	cpu_sibling_map
		cpumask_var_t*	node_to_cpumask_map
		int	acpi_disabled
		int	acpi_noirq
		int	acpi_pci_disabled
		int	audit_enabled
		int	cpu_number
		int	debug_locks
		int	disable_apic
		int	net_msg_warn
		int	nr_cpu_ids
		int	nr_online_nodes
		int	numa_node
		int	page_group_by_mobility_disabled
		int	percpu_counter_batch
		int	prof_on
		int	sched_mc_power_savings
		int	sched_smt_power_savings
		int	smp_found_config
		int	sysctl_max_syn_backlog
		int	sysctl_tcp_adv_win_scale
		int	sysctl_tcp_cookie_size
		int	sysctl_tcp_ecn
		int	sysctl_tcp_fin_timeout
		int	sysctl_tcp_keepalive_intvl
		int	sysctl_tcp_keepalive_probes
		int	sysctl_tcp_keepalive_time
		int	sysctl_tcp_low_latency
		int	sysctl_tcp_max_orphans
		int	sysctl_tcp_reordering
		int	sysctl_tcp_syncookies
		int	sysctl_tcp_tw_reuse
		int	tcp_memory_pressure
		int	time_status
		int	timer_stats_active
		int	x2apic_phys
		int	x86_cpu_to_node_map
		int*	console_printk
		int*	sysctl_tcp_mem
		int*	sysctl_tcp_rmem
		int*	sysctl_tcp_wmem
		int*	x86_cpu_to_node_map_early_ptr
		irq_cpustat_t	irq_stat
		long unsigned int	__kcrctab_ipv4_specific
		long unsigned int	__kcrctab_sysctl_tcp_low_latency
		long unsigned int	__kcrctab_tcp4_gro_complete
		long unsigned int	__kcrctab_tcp4_gro_receive
		long unsigned int	__kcrctab_tcp_hashinfo
		long unsigned int	__kcrctab_tcp_proc_register
		long unsigned int	__kcrctab_tcp_proc_unregister
		long unsigned int	__kcrctab_tcp_prot
		long unsigned int	__kcrctab_tcp_twsk_unique
		long unsigned int	__kcrctab_tcp_v4_conn_request
		long unsigned int	__kcrctab_tcp_v4_connect
		long unsigned int	__kcrctab_tcp_v4_destroy_sock
		long unsigned int	__kcrctab_tcp_v4_do_rcv
		long unsigned int	__kcrctab_tcp_v4_md5_do_add
		long unsigned int	__kcrctab_tcp_v4_md5_do_del
		long unsigned int	__kcrctab_tcp_v4_md5_hash_skb
		long unsigned int	__kcrctab_tcp_v4_md5_lookup
		long unsigned int	__kcrctab_tcp_v4_remember_stamp
		long unsigned int	__kcrctab_tcp_v4_send_check
		long unsigned int	__kcrctab_tcp_v4_syn_recv_sock
		long unsigned int	jiffies
		long unsigned int	kernel_stack
		long unsigned int	mmap_min_addr
		long unsigned int	mmu_cr4_features
		long unsigned int*	__per_cpu_offset
		long unsigned int*	cpu_bit_bitmap
		long unsigned int*	sysctl_local_reserved_ports
		nodemask_t*	node_states
		pg_data_t**	node_data
		physid_mask_t	phys_cpu_present_map
		pteval_t	__supported_pte_mask
		spinlock_t	dcache_lock
		struct address_space	swapper_space
		struct apic*	apic
		struct cache_sizes*	malloc_sizes
		struct cpuinfo_x86	boot_cpu_data
		struct cpuinfo_x86	cpu_info
		struct cpumask*	cpu_online_mask
		struct cpumask*	cpu_possible_mask
		struct cpumask*	cpu_present_mask
		struct device	x86_dma_fallback_dev
		struct dma_map_ops*	dma_ops
		struct dqstats	dqstats
		struct icmp_err*	icmp_err_convert
		struct inet_connection_sock_af_ops	ipv4_specific
		struct inet_hashinfo	tcp_hashinfo
		struct inet_timewait_death_row	tcp_death_row
		struct kernel_symbol	__ksymtab_ipv4_specific
		struct kernel_symbol	__ksymtab_sysctl_tcp_low_latency
		struct kernel_symbol	__ksymtab_tcp4_gro_complete
		struct kernel_symbol	__ksymtab_tcp4_gro_receive
		struct kernel_symbol	__ksymtab_tcp_hashinfo
		struct kernel_symbol	__ksymtab_tcp_proc_register
		struct kernel_symbol	__ksymtab_tcp_proc_unregister
		struct kernel_symbol	__ksymtab_tcp_prot
		struct kernel_symbol	__ksymtab_tcp_twsk_unique
		struct kernel_symbol	__ksymtab_tcp_v4_conn_request
		struct kernel_symbol	__ksymtab_tcp_v4_connect
		struct kernel_symbol	__ksymtab_tcp_v4_destroy_sock
		struct kernel_symbol	__ksymtab_tcp_v4_do_rcv
		struct kernel_symbol	__ksymtab_tcp_v4_md5_do_add
		struct kernel_symbol	__ksymtab_tcp_v4_md5_do_del
		struct kernel_symbol	__ksymtab_tcp_v4_md5_hash_skb
		struct kernel_symbol	__ksymtab_tcp_v4_md5_lookup
		struct kernel_symbol	__ksymtab_tcp_v4_remember_stamp
		struct kernel_symbol	__ksymtab_tcp_v4_send_check
		struct kernel_symbol	__ksymtab_tcp_v4_syn_recv_sock
		struct list_head*	nf_hooks
		struct mem_section**	mem_section
		struct memnode	memnode
		struct neigh_table	nd_tbl
		struct nf_afinfo**	nf_afinfo
		struct percpu_counter	tcp_orphan_count
		struct percpu_counter	tcp_sockets_allocated
		struct pernet_operations	tcp4_net_ops
		struct pernet_operations	tcp_sk_ops
		struct pglist_data**	node_data
		struct pid*	cad_pid
		struct pid_namespace	init_pid_ns
		struct proto	tcp_prot
		struct pt_regs*	irq_regs
		struct pv_apic_ops	pv_apic_ops
		struct pv_cpu_ops	pv_cpu_ops
		struct pv_info	pv_info
		struct pv_irq_ops	pv_irq_ops
		struct pv_mmu_ops	pv_mmu_ops
		struct pv_time_ops	pv_time_ops
		struct request_sock_ops	tcp_request_sock_ops
		struct resource	ioport_resource
		struct rps_sock_flow_table*	rps_sock_flow_table
		struct sk_buff*	skb
		struct smp_ops	smp_ops
		struct sock*	sk
		struct task_struct*	current_task
		struct tcp_congestion_ops	tcp_init_congestion_ops
		struct tcp_request_sock_ops	tcp_request_sock_ipv4_ops
		struct tcp_seq_afinfo	tcp4_seq_afinfo
		struct tcp_sock_af_ops	tcp_sock_ipv4_specific
		struct timewait_sock_ops	tcp_timewait_sock_ops
		struct tracepoint	__tracepoint_irq_handler_entry
		struct tracepoint	__tracepoint_irq_handler_exit
		struct tracepoint	__tracepoint_kfree
		struct tracepoint	__tracepoint_kmalloc
		struct tracepoint	__tracepoint_kmalloc_node
		struct tracepoint	__tracepoint_kmem_cache_alloc
		struct tracepoint	__tracepoint_kmem_cache_alloc_node
		struct tracepoint	__tracepoint_kmem_cache_free
		struct tracepoint	__tracepoint_mm_page_alloc
		struct tracepoint	__tracepoint_mm_page_alloc_extfrag
		struct tracepoint	__tracepoint_mm_page_alloc_zone_locked
		struct tracepoint	__tracepoint_mm_page_free_direct
		struct tracepoint	__tracepoint_mm_page_pcpu_drain
		struct tracepoint	__tracepoint_mm_pagevec_free
		struct tracepoint	__tracepoint_module_free
		struct tracepoint	__tracepoint_module_get
		struct tracepoint	__tracepoint_module_load
		struct tracepoint	__tracepoint_module_put
		struct tracepoint	__tracepoint_module_request
		struct tracepoint	__tracepoint_softirq_entry
		struct tracepoint	__tracepoint_softirq_exit
		struct tracepoint	__tracepoint_softirq_raise
		struct vm_event_state	vm_event_states
		struct x86_init_ops	x86_init
		struct x86_platform_ops	x86_platform
		u16	x86_bios_cpu_apicid
		u32	inet_ehash_secret
		union irq_stack_union	irq_stack_union
		unsigned int	apic_verbosity
		unsigned int	sysctl_timer_migration

- Arnaldo
