Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab2KINdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 08:33:33 -0500
Received: from zimbra.linbit.com ([212.69.161.123]:50404 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab2KINda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 08:33:30 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] drbd-8.4.2 for the linux-3.8 merge window
Date: Fri, 09 Nov 2012 14:33:26 +0100
Message-ID: <1670685.HQRLhryL3A@fat-tyre>
User-Agent: KMail/4.8.5 (Linux/3.2.0-32-generic; KDE/4.8.5; x86_64; ; )
In-Reply-To: <509CFD70.5020807@kernel.dk>
References: <3042269.jrNem7z1LI@fat-tyre> <4229483.8Hqs9YQUgX@fat-tyre> <509CFD70.5020807@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens, here it is without the sysfs stuff


The following changes since commit ccae7868b0c5697508a541c531cf96b361d62c1c:

  drbd: log request sector offset and size for IO errors (2012-10-30 08:39:18 +0100)

are available in the git repository at:

  git://git.drbd.org/linux-drbd.git for-jens_drbd-8.4.2

for you to fetch changes up to f1d6a328bbe63b528721a25251ad8f5f1e997804:

  drbd: use copy_highpage (2012-11-09 14:22:26 +0100)

----------------------------------------------------------------
Akinobu Mita (1):
      drbd: use copy_highpage

Andreas Gruenbacher (210):
      drbd: Get rid of req_validator_fn typedef
      drbd: Remove superfluous declaration
      drbd: Consistently use block_id == ID_SYNCER for checksum based resync and online verify
      drbd: Get rid of BE_DRBD_MAGIC and BE_DRBD_MAGIC_BIG
      drbd: Endianness convert the constants instead of the variables
      drbd: Magic reserved block_id value cleanup
      drbd: Move drbd_free_tl_hash() to drbd_main()
      drbd: Update outdated comment
      drbd: Request lookup code cleanup (1)
      drbd: Request lookup code cleanup (2)
      drbd: Request lookup code cleanup (3)
      drbd: Request lookup code cleanup (4)
      drbd: Add interval tree data structure
      drbd: Put sector and size in struct drbd_request into struct drbd_interval
      drbd: Use interval tree for overlapping write request detection
      drbd: Add read_requests tree
      drbd: Use the read and write request trees for request lookups
      drbd: Put sector and size in struct drbd_epoch_entry into struct drbd_interval
      drbd: Use interval tree for overlapping epoch entry detection
      drbd: Remove the unused hash tables
      drbd: Convert all constants in enum drbd_req_event to upper case
      drbd: Convert all constants in enum drbd_thread_state to upper case
      drbd: Replace the ERR_IF macro with an assert-like macro
      drbd: Remove some useless paranoia code
      drbd: Inline function overlaps() is now unused
      drbd: Interval tree bugfix
      drbd: Move cmdname() out of drbd_int.h
      drbd: Rename "enum drbd_packets" to "enum drbd_packet"
      drbd: Remove redundant initialization
      drbd: Initialize the sequence number sent over the network even when not used
      drbd: Move sequence number logic into drbd_receiver.c and simplify it
      drbd: Move some functions to where they are used
      drbd: struct drbd_request: Introduce a new collision flag
      drbd: Remove redundant check from drbd_contains_interval()
      drbd: Allow to wait for the completion of an epoch entry as well
      drbd: _req_conflicts(): Get rid of the epoch_entries tree
      drbd: Remove unnecessary reference counting left-over
      drbd: Defer new writes when detecting conflicting writes
      drbd: Make the peer_seq updating code more obvious
      drbd: Improve the drbd_find_overlap() documentation
      drbd: Remove unused variable in struct drbd_conf
      drbd: Rename struct drbd_epoch_entry to struct drbd_peer_request
      drbd: Clean up some left-overs
      drbd: Update some comments
      drbd: Local variable renames: e -> peer_req
      drbd: Rename drbd_submit_ee -> drbd_submit_peer_request
      drbd: Rename drbd_endio_{pri,sec} -> drbd_{,peer_}request_endio
      drbd: Iterate over all overlapping intervals in a tree
      drbd: Remove obsolete comment
      drbd: Use the IS_ALIGNED() macro in some more places
      drbd: Use container_of() instead of casting
      drbd: Concurrent write detection fix
      drbd: Replace atomic_add_return with atomic_inc_return
      drbd: Use ping-timeout when waiting for missing ack packets
      drbd: Improve how conflicting writes are handled
      drbd: Remove redundant check
      drbd: Get rid of P_MAX_CMD
      drbd: Replace get_asender_cmd() with its implementation
      drbd: Remove left-over function prototypes
      drbd: drbd_send(): Return a "real" error code if we have no socket
      drbd: drbd_get_data_sock(): Return 0 upon success and an error code otherwise
      drbd: Add drbd_send_all(): Send an entire buffer
      drbd: conn_send_cmd2(): Return 0 upon success and an error code otherwise
      drbd: _conn_send_cmd(): Return 0 upon success and an error code otherwise
      drbd: _drbd_send_cmd(): Return 0 upon success and an error code otherwise
      drbd: conn_send_cmd(): Return 0 upon success and an error code otherwise
      drbd: Get rid of USE_DATA_SOCKET and USE_META_SOCKET
      drbd: drbd_send_cmd(): Return 0 upon success and an error code otherwise
      drbd: drbd_send_sync_param(): Return 0 upon success and an error code otherwise
      drbd: drbd_send_state(): Return 0 upon success and an error code otherwise
      drbd: drbd_send_handshake(): Return 0 upon success and an error code otherwise
      drbd: drbd_send_protocol(): Return 0 upon success and an error code otherwise
      drbd: drbd_send_uuids() and its variants: Return 0 upon success and an error code otherwise
      drbd: drbd_gen_and_send_sync_uuid(): Return void: the result is never used
      drbd: drbd_send_sizes(): Return 0 upon success and an error code otherwise
      drbd: _conn_send_state_req(): Return 0 upon success and an error code otherwise
      drbd: conn_send_state_req(): Return 0 upon success and an error code otherwise
      drbd: drbd_send_state_req(): Return 0 upon success and an error code otherwise
      drbd: drbd_send_sr_reply(): Return void: the result is never used
      drbd: drbd_send_b_ack(): Return void: the result is never used
      drbd: _drbd_send_ack(): Return 0 upon success and an error code otherwise
      drbd: drbd_send_ack(): Return 0 upon success and an error code otherwise
      drbd: drbd_send_ack_{dp,rp}(): Return void: the result is never used
      drbd: drbd_send_ack_ex(): Return 0 upon success and an error code otherwise
      drbd: drbd_send_ov_request(): Return 0 upon success and an error code otherwise
      drbd: drbd_send_drequest(): Return 0 upon success and an error code otherwise
      drbd: drbd_send_drequest_csum(): Return 0 upon success and an error code otherwise
      drbd: drbd_send_oos(): Return 0 upon success and an error code otherwise
      drbd: _drbd_no_send_page(): Return 0 upon success and an error code otherwise
      drbd: _drbd_send_page(): Return 0 upon success and an error code otherwise
      drbd: _drbd_send_zc_ee(): Return 0 upon success and an error code otherwise
      drbd: drbd_send_block(): Return 0 upon success and an error code otherwise
      drbd: _drbd_send_bio(), _drbd_send_zc_bio(): Return 0 upon success and an error code otherwise
      drbd: drbd_send_dblock(): Return 0 upon success and an error code otherwise
      drbd: drbd_send_short_cmd(): Return 0 upon success and an error code otherwise
      drbd: Temporarily change the return type of all worker callbacks
      drbd: Make all worker callbacks return 0 upon success and an error code otherwise
      drbd: drbd_process_done_ee(): Return 0 upon success and an error code otherwise
      drbd: decode_header(): Return 0 upon success and an error code otherwise
      drbd: drbd_recv_header(): Return 0 upon success and an error code otherwise
      drbd: drbd_drain_block(): Return 0 upon success and an error code otherwise
      drbd: recv_dless_read(): Return 0 upon success and an error code otherwise
      drbd: recv_resync_read(): Return 0 upon success and an error code otherwise
      drbd: send_bitmap_rle_or_plain(): Error handling cleanup
      drbd: Add drbd_recv_all(): Receive an entire buffer
      drbd: Make all command handlers return 0 upon success and an error code otherwise
      drbd: drbd_bm_read() never returns a positive value through drbd_bitmap_io()
      drbd: _drbd_md_sync_page_io(): Return 0 upon success and an error code otherwise
      drbd: drbd_md_sync_page_io(): Return 0 upon success and an error code otherwise
      drbd: Remove duplicate initialization
      drbd: Remove unnecessary assertion
      drbd: drbd_may_do_local_read(): Use bool/true/false
      drbd: Rename various functions from *_oos_* to *_out_of_sync_* for clarity
      drbd: Get rid of typedef drbd_work_cb
      drbd: Introduce and use drbd_recv_all_warn()
      drbd: drbd_connected(): Return an error code upon failure.
      drbd: Always use the same protocol version for the same peer
      drbd: Move drbd_send_ping() and drbd_send_ping_ack() to drbd_main.c
      drbd: Make _drbd_send_bitmap() static
      drbd: Rename the DCBP_* functions to dcbp_* and move them to where they are used
      drbd: Preallocate one page per drbd_socket as a receive buffer
      drbd: receive_bitmap(): Use the pre-allocated receive buffer
      drbd: Preallocate one page per drbd_socket as a send buffer
      drbd: _drbd_send_bitmap(): Use the pre-allocated send buffer
      drbd: A small cleanup in drbdd()
      drbd: Remove useless error messages
      drbd: Pass struct packet_info down to the receive functions
      drbd: Map from (connection, volume number) to device in the receive handlers
      drbd: Pass struct packet_info down to the asender receive functions
      drbd: Map from (connection, volume number) to device in the asender handlers
      drbd: drbd_connect(): Initialize struct drbd_socket before sending anything
      drbd: _conn_send_cmd(), _drbd_send_cmd(): Pass a struct drbd_socket instead of a plain socket
      drbd: Change how the initial packets are called
      drbd: Change how the "handshake" packets are called
      drbd: drbd_send_ping(), drbd_send_ping(): Return 0 upon success and an error code otherwise
      drbd: Introduce new primitives for sending commands
      drbd: Introduce drbd_header_size()
      drbd: Replace and remove old primitives
      drbd: Remove now-unused int_dig_out buffer
      drbd: Remove some fixed header size assumptions
      drbd: Remove headers from on-the-wire data structures (struct p_*)
      drbd: Introduce protocol version 100 headers
      drbd: Removed outdated comments and code that envisioned VNRs in header 95
      drbd: validate_req_change_req_state(): Return 0 upon success and an error code otherwise
      drbd: Make all asynchronous command handlers return 0 upon success and an error code otherwise
      drbd: drbd_init_ee() no longer exists
      drbd: Rename drbd_alloc_ee() to drbd_alloc_peer_req()
      drbd: Rename drbd_free_ee() and variants to *_peer_req()
      drbd: Rename drbd_release_ee() to drbd_free_peer_reqs()
      drbd: Rename reclaim_net_ee(), drbd_process_done_ee(), drbd_process_done_ee(), tconn_process_done_ee() to *_peer_reqs
      drbd: Rename drbd_{ ee -> peer_req }_has_active_page
      drbd: Make drbd_wait_ee_list_empty() and _drbd_wait_ee_list_empty() static
      drbd: Rename drbd_pp_first_pages_or_try_alloc() to __drbd_alloc_pages()
      drbd: Rename drbd_pp_alloc() to drbd_alloc_pages() and make it non-static
      drbd: Rename drbd_pp_free() to drbd_free_pages()
      drbd: Wrong use of RCU in receive_protocol()
      drbd: Rename integrity_w_tfm -> integrity_tfm
      drbd: Rename integrity_r_tfm -> peer_integrity_tfm
      drbd: Remove obsolete drbd_crypto_is_hash()
      drbd: Introduce a "lockless" variant of drbd_send_protocoll()
      drbd: Allow to change data-integrity-alg on the fly
      drbd: Remove left-over unused define
      drbd: Generate the drbd_set_*_defaults() functions from drbd_genl.h
      drbd: Convert boolean flags on netlink from NLA_FLAG to NLA_U8
      drbd: Turn no-disk-flushes into disk-flushes={yes|no}
      drbd: Turn no-disk-drain into disk-drain={yes|no}
      drbd: Turn no-md-flushes into md-flushes={yes|no}
      drbd: Turn no-tcp-cork into tcp-cork={yes|no}
      drbd: Make broadcast events return NO_ERROR
      drbd: Also define the default values of boolean flags in a single place
      drbd: Rename the want_lose field/flag to discard_my_data
      drbd: Refer to resync-rate consistently throughout the code
      drbd: Refer to connect-int consistently throughout the code
      drbd: Fix the upper limit of resync-after
      drbd: Convert resync-after into a signed netlink field
      drbd: Rename DISK_SIZE_SECT -> DISK_SIZE
      drbd: Use more generic constant names
      drbd: Output signed / unsigned netlink fields correctly
      drbd: Remove unused GENLA_F_MAY_IGNORE flag
      drbd: Make drbd's use of netlink attribute flags less confusing
      drbd: drbd_nla_check_mandatory(): Need to remove the DRBD_GENLA_F_MANDATORY flag first
      drbd: drbd_adm_prepare(): Pass through error codes
      drbd: Don't use empty nested netlink attributes
      drbd: Use DRBD_MINOR_COUNT_DEF in one more place
      drbd: Use the terminology suggested by the command names in the source code and messages
      drbd: Also need to check for DRBD_GENLA_F_MANDATORY flags before nla_find_nested()
      drbd: Split off netlink mandatory attribute handling into separate file
      drbd: Rename DRBD_ADM_NEED_{CONN -> RESOURCE}
      drbd: Convert the generic netlink interface to accept connection endpoints
      drbd: Allow to pass resource options to the new-resource command
      drbd: Remove dead code
      drbd: Rename --dry-run to --tentative
      drbd: Improve the "unexpected packet" error messages
      drbd: Define scale factors in a single place
      drbd: Fix the maximum accepted minor device number
      drbd: Allow to create devices with a minor number > minor_count
      drbd: Print memory address in hex instead of decimal in error message
      drbd: receive_protocol(): Give variables more easily searchable names
      drbd: receive_protocol(): Make the program flow less confusing
      drbd: Be consistent in reporting incompatibilities in P_PROTOCOL settings
      drbd: receive_protocol(): We cannot change our own data-integrity-alg setting here
      drbd: Turn tl_apply() into tl_abort_disk_io()
      drbd: Fix the data-integrity-alg setting
      drbd: Get rid of MR_{READ,WRITE}_SHIFT
      drbd: Update some outdated comments to match the code
      drbd: Improve error reporting in drbd_md_sync_page_io()
      drbd: Remove leftover prototype
      drbd: drbd_bm_ALe_set_all(): Remove unused function
      drbd: Stop using NLA_PUT*().
      drbd: Don't unregister socket state_change callback from within the callback

David Howells (1):
      DRBD: Fix comparison always false warning due to long/long long compare

Jing Wang (1):
      drbd: check return of kmalloc in receive_uuids

Lars Ellenberg (135):
      drbd: simplify condition in drbd_may_do_local_read()
      drbd: fix typo in comment
      drbd: in drbd_suspend_al, set AL_SUSPENDED before unlocking the activity log
      drbd: use clear_bit_unlock() where appropriate
      lru_cache.h: fix comments referring to ts_ instead of lc_
      lru_cache: consolidate lc_get and lc_try_get
      drbd: allow to select specific bitmap pages for writeout
      lru_cache: allow multiple changes per transaction
      drbd: new on-disk activity log transaction format
      drbd: silence some log messages on bitmap IO
      drbd: fix a wrong likely(), updated comments
      drbd: remove unused define
      drbd: default to detach on-io-error
      drbd: only wakeup if something changed in update_peer_seq
      drbd: add page pool to be used for meta data IO
      drbd: use the newly introduced page pool for bitmap IO
      drbd: introduce a bio_set to allocate housekeeping bios from
      drbd: fix drbd_delete_device: remove vnr from volumes; idr_remove(); synchronize_rcu(); before cleanup
      drbd: get rid of drbd_bcast_ee, it is of no use anymore
      drbd: prepare the transition from connector to genetlink
      drbd: switch configuration interface from connector to genetlink
      drbd: allow holes in minor and volume id allocation
      drbd: remove now unused connector related files
      drbd: drbd_adm_get_status needs to show some more detail
      drbd: simplify conn_all_vols_unconf, make it bool
      drbd: Allow a Diskless Secondary volume to be removed
      drbd: new-connection and new-minor succeed, if the object already exists
      drbd: bail out if a config requrest is over-determined, and not matching
      drbd: add forgotten spin_unlock
      drbd: introduce in-kernel "down" command
      drbd: fix conn_reconfig_start without conn_reconfig_done in drbd_adm_attach
      drbd: distribute former syncer_conf settings to disk, connection, and resource level
      drbd: introduce the "initialized" activity log transaction type
      drbd: preparation commit, pass drbd_interval to drbd_al_begin/complete_io
      drbd: prepare to activate two activity log extents at once
      drbd: get rid of bio_split, allow bios of "arbitrary" size
      drbd: improvements to activate/deactivate multiple activity log extents
      drbd: allow status dump request all volumes of a specific resource
      drbd: fix setsockopt for user mode linux
      drbd: cmdname() enum to string convertion was missing a few constants
      drbd: move comment about stopping the receiver thread to where it belongs
      drbd: remove useless kobject_uevent from drbd_adm_connect
      drbd: fix various disconnecting races
      drbd: on reconfiguration requests, mind the SET_DEFAULTS flag
      drbd: rename variable ndc to new_disk_conf
      drbd: rename variable sc to res_opts
      drbd: fix copy/paste error in comment
      drbd: fix race when forcefully disconnecting
      drbd: fix thread stop deadlock
      drbd: fix schedule in atomic
      drbd: Introduce __s32_field in the genetlink macro magic
      drbd: skip spurious wait_event in drbd_al_begin_io
      drbd: cosmetic: fix accidental division instead of modulo when pretty printing
      drbd: spelling fix: too small
      drbd: allow ping-timeout of up to 30 seconds
      drbd: downgraded error printk to info
      drbd: on attach, enforce clean meta data
      drbd: report net config even for resources without a single volume
      drbd: detach must not try to abort non-local requests
      drbd: fix connect failure with all default net-options
      drbd: fix bitmap writeout after aborted resync
      drbd: add missing rcu locks around recently introduced idr_for_each
      drbd: explicitly clear unused dp_flags in drbd_send_block
      drbd: Fix a potential race that could case data inconsistency
      drbd: Fix a potential write ordering issue on SyncTarget nodes
      drbd: Fixed detach
      drbd: fix potential data corruption and protocol error
      drbd: remove now unused seq_num member from struct drbd_request
      drbd: missing wakeup after drbd_rs_del_all
      drbd: fix memleak in error path in bm_rw and drbd_bm_write_range
      drbd: remove some very outdated comments
      drbd: remove unused static helper function
      drbd: don't pretend that barrier_nr == 0 was special
      drbd: fix potential deadlock during "restart" of conflicting writes
      drbd: make OOS_HANDED_TO_NETWORK its own case
      drbd: fix READ_RETRY_REMOTE_CANCELED to not complete if device is suspended
      drbd: fix WRITE_ACKED_BY_PEER_AND_SIS to not set RQ_NET_DONE
      drbd: conflicting writes: make wake_up of waiting peer_requests explicit
      drbd: factor out master_bio completion and drbd_request destruction paths
      drbd: move put_ldev from __req_mod() to the endio callback
      drbd: simplify retry path of failed READ requests
      drbd: complete_conflicting_writes() should not care about connections
      drbd: ignore volume number for drbd barrier packet exchange
      drbd: fix resend/resubmit of frozen IO
      drbd: fix race between drbdadm invalidate/verify and finishing resync
      drbd: allow bitmap to change during writeout from resync_finished
      drbd: bm_page_async_io: properly initialize page->private
      drbd: grammar fix in log message
      drbd: fix access of unallocated pages and kernel panic
      drbd: fix local read error hung forever
      drbd: fix wrong assert in completion/retry path of failed local reads
      drbd: rename drbd_restart_write to drbd_restart_request
      drbd: transfer log epoch numbers are now per resource
      drbd: allow to dequeue batches of work at a time
      drbd: move the drbd_work_queue from drbd_socket to drbd_connection
      drbd: remove struct drbd_tl_epoch objects (barrier works)
      drbd: better separate WRITE and READ code paths in drbd_make_request
      drbd: __drbd_make_request() is now void
      drbd: introduce completion_ref and kref to struct drbd_request
      drbd: base completion and destruction of requests on ref counts
      drbd: __req_mod: make DISCARD_WRITE and independend case
      drbd: allow read requests to be retried after force-detach
      drbd: take error path in drbd_adm_down if interrupted by signal
      drbd: fix null pointer dereference with on-congestion policy when diskless
      drbd: cleanup, remove two unused global flags
      drbd: differentiate between normal and forced detach
      drbd: report congestion if we are waiting for some userland callback
      drbd: reset congestion information before reporting it in /proc/drbd
      drbd: do not reset rs_pending_cnt too early
      drbd: call local-io-error handler early
      drbd: flush drbd work queue before invalidate/invalidate remote
      drbd: introduce stop-sector to online verify
      drbd: announce FLUSH/FUA capability to upper layers
      drbd: fix drbd wire compatibility for empty flushes
      drbd: Fix a potential issue with the DISCARD_CONCURRENT flag
      drbd: only start a new epoch, if the current epoch contains writes
      drbd: NEG_ACK does not imply a barrier-ack
      drbd: cleanup, drop unused struct
      drbd: disambiguation, s/P_DISCARD_WRITE/P_SUPERSEDED/
      drbd: disambiguation, s/DISCARD_CONCURRENT/RESOLVE_CONFLICTS/
      drbd: disambiguation, s/ERR_DISCARD/ERR_DISCARD_IMPOSSIBLE/
      drbd: properly call drbd_rs_cancel_all() in drbd_disconnected()
      drbd: don't send out P_BARRIER with stale information
      drbd: temporarily suspend io in drbd_adm_disk_opts
      drbd: mutex_unlock "... must no be used in interrupt context"
      drbd: dequeue single work items in wait_for_work()
      drbd: fix potential list_add corruption
      drbd: differentiate early and later "postponing" of requests
      drbd: use list_move_tail instead of list_del/list_add_tail
      drbd: fix potential deadlock during bitmap (re-)allocation
      drbd: a few more GFP_KERNEL -> GFP_NOIO
      drbd: wait for meta data IO completion even with failed disk, unless force-detached
      drbd: always write bitmap on detach
      drbd: log request sector offset and size for IO errors
      drbd: if the replication link breaks during handshake, keep retrying

Philipp Marek (1):
      drbd: pass some more information to userspace.

Philipp Reisner (232):
      idr: idr_for_each_entry() macro
      drbd: Minimal struct drbd_tconn
      drbd: moved net_conf from mdev to tconn
      drbd: moved net_cont and net_cnt_wait from mdev to tconn
      drbd: moved data and meta from mdev to tconn
      drbd: moved receiver, worker and asender from mdev to tconn
      drbd: moved agreed_pro_version, last_received and ko_count to tconn
      drbd: moved req_lock and transfer log from mdev to tconn
      drbd: moved crypto transformations and friends from mdev to tconn
      drbd: Made drbd_flush_workqueue() to take a tconn instead of an mdev
      drbd: Preparing to use p_header96 for all packets
      drbd: Replaced all p_header80 with a generic p_header
      drbd: Use new header layout
      drbd: Implemented receiving of new style packets on meta socket
      drbd: Do not access tconn after it was freed
      drbd: Moved the state functions into its own source file
      drbd: Moved the thread name into the data structure
      drbd: Eliminated the user of drbd_task_to_thread()
      drbd: Moved code
      drbd: Do no sleep long in drbd_start_resync
      drbd: Revert "Make sure we dont send state if a cluster wide state change is in progress"
      drbd: Moving state related macros to drbd_state.h
      drbd: conn_printk() a dev_printk() alike for drbd's connections
      drbd: Converted drbd_try_connect() from mdev to tconn
      drbd: Converted drbd_wait_for_connect() from mdev to tconn
      drbd: Started to separated connection flags (tconn) from block device flags (mdev)
      drbd: Moved DISCARD_CONCURRENT to the per connection (tconn) flags
      drbd: Moved SEND_PING to the per connection (tconn) flags
      drbd: Moved SIGNAL_ASENDER to the per connection (tconn) flags
      drbd: Converted wake_asender() and request_ping() from mdev to tconn
      drbd: Converted helper functions for drbd_send() to tconn
      drbd: Converted drbd_send() from mdev to tconn
      drbd: Converted drbd_send_fp() from mdev to tconn
      drbd: Removed unused mdev argument from drbd_recv_short() and drbd_socket_okay()
      drbd: Converted drbd_recv_fp() from mdev to tconn
      drbd: Converted drbd_send_handshake() from mdev to tconn
      drbd: Converted drbd_recv() from mdev to tconn
      drbd: struct packet_info to hold information of decoded packets
      drbd: Converted decode_header() from mdev to tconn
      drbd: Converted drbd_recv_header() from mdev to tconn
      drbd: Converted drbd_do_handshake() from mdev to tconn
      drbd: Converted drbd_(get|put)_data_sock() and drbd_send_cmd2() to tconn
      drbd: Converted drbd_do_auth() from mdev to tconn
      drbd: Converted drbd_send_protocol() from mdev to tconn
      drbd: Use and idr data structure to map volume numbers to mdev pointers
      drbd: Converted drbd_connect() from mdev to tconn
      drbd: Converted drbd_calc_cpu_mask() and drbd_thread_current_set_cpu() from mdev to tconn
      drbd: Converted drbdd() from mdev to tconn
      drbd: Converted drbd_free_sock() and drbd_disconnect() from mdev to tconn
      drbd: Moved the mdev member into drbd_work (from drbd_request and drbd_peer_request)
      drbd: Consolidated the setup of the thread name into the framework
      drbd: Converted drbdd_init() from mdev to tconn
      drbd: Converted drbd_asender() from mdev to tconn
      drbd: Converted drbd_worker() from mdev to tconn
      drbd: drbd_thread has now a pointer to a tconn instead of to a mdev
      drbd: Moved some initializing code into drbd_new_tconn()
      drbd: Generalized the work callbacks
      drbd: Converted drbd_send_ping() and related functions from mdev to tconn
      drbd: Extracted after_conn_state_ch() out of after_state_ch()
      drbd: Renamed is_valid_state_transition() to is_valid_soft_transition()
      drbd: Extracted is_valid_transition() out of sanitize_state()
      drbd: Extracted is_valid_conn_transition() out of is_valid_transition()
      drbd: Removed the os parameter form sanitize_state()
      drbd: Code de-duplication; new function apply_mask_val()
      drbd: Killed volume0; last step of multi-volume-enablement
      drbd: Removed drbd_state_lock() and drbd_state_unlock()
      drbd: Introduced tconn->cstate_mutex
      drbd: Implemented conn_send_state_req()
      drbd: Global_state_lock not necessary here...
      drbd: Implemented receiving of P_CONN_ST_CHG_REPLY
      drbd: implemented receiving of P_CONN_ST_CHG_REQ
      drbd: Implemented connection wide state changes
      drbd: Reworked the unconfiguring and thread stopping code
      drbd: Removed the mdev parameter from the ..to_tags() and ...from_tags() functions
      drbd: Improved the dec_*() macros
      drbd: Converted the transfer log from mdev to tconn
      drbd: Preparing the connector interface to operator on connections
      drbd: Converted drbd_nl_(net_conf|disconnect)() from mdev to tconn
      drbd: Implemented new commands to create/delete connections/minors
      drbd: Replaced the minor_table array by an idr
      drbd: Ignore packets for non existing volumes
      drbd: process_done_ee() has to handle unconfigured devices now
      drbd: New minors have to intherit the connection state form their connection
      drbd: Allow two diskless minors to be connected
      drbd: Do not modify the connection state with something else that conn_request_state()
      drbd: Moved CONN_DRY_RUN to the per connection (tconn) flags
      drbd: Allow packet handler functions that take a connection
      drbd: Converted receive_protocol() from mdev to tconn
      drbd: Separate connection state changes from minor dev state changes #1
      drbd: Allow packet handler functions that take a connection (meta connection)
      drbd: Converted got_Ping() and got_PingAck() from mdev to tconn
      drbd: Separate connection state changes from minor dev state changes #2
      drbd: Allow volumes to become primary only on one side
      drbd: conn_khelper() for user mode callbacks for connections
      drbd: Fixed conn_lowest_minor
      drbd: Converted drbd_try_outdate_peer() from mdev to tconn
      drbd: Use the idr_for_each_entry() iterator instead of idr_for_each()
      drbd: Fixed logging of old connection state
      drbd: Print common state changes of all volumes as connection state changes
      drbd: Allow to disconnect if one volume is diskless
      drbd: Do not segfault if a sync dependency reaches a diskless device
      drbd: Introduced drbd_read_state()
      drbd: Renamed id_susp(union drbd_state s) to drbd_suspended(struct drbd_conf *)
      drbd: Moved susp, susp_nod and susp_fen to the connection object
      drbd: Introduced a new type union drbd_dev_state
      drbd: Renamed nms to ns_max
      drbd: Calculate and provide ns_min to the w_after_conn_state_ch() work
      drbd: Implemented conn_lowest_conn()
      drbd: Implemented conn_lowest_disk()
      drbd: Implemented IO thawing for multiple volumes
      drbd: Improved logging of state changes
      drbd: Use tconn in request_timer_fn()
      drbd: drbd_delete_device() takes a struct drbd_conf * now
      drbd: Inlined drbd_free_mdev(); it got called only from one place
      drbd: rcu_read_[un]lock() for all idr accesses that do not sleep
      drbd: Converted drbd_cfg_mutex into drbd_cfg_rwsem
      drbd: protect all idr accesses that might sleep with drbd_cfg_rwsem
      drbd: Runtime changeable wire protocol
      drbd: Check consistency of net options when the get changed online
      drbd: Allow online change of replication protocol only with agreed_pv >= 100
      drbd: rcu_read_lock() and rcu_dereference() for tconn->net_conf
      drbd: Proper locking for updates to net_conf under RCU
      drbd: Considering that the two_primaries config flag can change
      drbd: Eliminated drbd_free_resoruces() it is superseeded by conn_free_crypto()
      drbd: Basic refcounting for drbd_tconn
      drbd: Take a reference on tconn when finding a tconn by name
      drbd: Removed the OBJECT_DYING and the CONFIG_PENDING bits
      drbd: Consider all crypto options in connect and in net-options
      drbd: Removed dead code
      drbd: Renamed the net_conf_update mutex to conf_update
      drbd: drbd_dew_dev_size() gets the user requests disk_size as argument
      drbd: Split drbd_alter_sa() into drbd_sync_after_valid() and drbd_sync_after_changed()
      drbd: Renamed (old|new)_conf into (old|new)_net_conf in receive_SyncParam
      drbd: RCU for disk_conf
      drbd: Made the fifo object a self contained object (preparing for RCU)
      drbd: Enforce limits of disk_conf members; centralized these checks
      drbd: RCU for rs_plan_s
      drbd: Refcounting for mdev objects
      drbd: Use RCU for the drbd_tconns list
      drbd: Removing drbd_cfg_rwsem
      drbd: Refuse to change network options online when...
      drbd: protect updates to integrits_tfm by tconn->data->mutex
      drbd: Made cmp_after_sb() more generic into convert_after_sb()
      drbd: Allocation of int_dig_in and int_dig_vv was missing
      drbd: Receiving part for the PROTOCOL_UPDATE packet
      drbd: Send PROTOCOL_UPDATE packets when appropriate
      drbd: Lower log priority for an event that is definitely not an error
      drbd: Fixes from the 8.3 development branch
      drbd: Improve compatibility with drbd's older than 8.3.7
      drbd: Fixed state transitions in case reading meta data failes
      drbd: detach from frozen backing device
      drbd: Fixed removal of volumes/devices from connected resources
      drbd: Eliminated the "notified peer" messages
      drbd: Correctly handle resources without volumes
      drbd: Changed some defaults
      drbd: Dropped wrong clause to generate new current UUIDs
      drbd: Consider that the no-data-condition could be in connected state
      drbd: Do not mod_timer() with a past time
      drbd: Missing assignment of mdev before drbd_queue_work()
      drbd: Fixed w_restart_disk_io() to handle non active AL-extents
      drbd: Bugfix for the connection behavior
      drbd: Do not display bogus log lines for pdsk in case pdsk < D_UNKNOWN
      drbd: The minor_count module parameter is only a hint nowadays
      drbd: Cleanup all epoch objects upon connection loss
      drbd: Remove dead code
      drbd: Remove unused code
      drbd: Consider the discard-my-data flag for all volumes [bugz 359]
      drbd: fix "stalled" empty resync
      drbd: Silenced compiler warnings
      drbd: Fixes from the drbd-8.3 branch
      drbd: Fixes from the drbd-8.3 branch
      drbd: Fixed an obvious copy-n-paste mistake
      drbd: Move the CREATE_BARRIER flag from connection to device
      drbd: Move write_ordering from mdev to tconn
      drbd: Prepare epochs per connection
      drbd: Move list of epochs from mdev to tconn
      drbd: Switch drbd_may_finish_epoch() from mdev to tconn
      drbd: Fix the WO=drain implementation for multiple volumes
      drbd: fix potential spinlock deadlock
      drbd: Get rid of "ASSERTION FAILED: tconn->current_epoch->list not empty"
      drbd: Load balancing of read requests
      drbd: Load balancing method: striping
      drbd: Do not call generic_make_request() while holding req_lock
      drbd: fix race between disconnect and receive_state
      drbd: Do not send state packets while lower than C_CONNECTED cstate
      drbd: Consider that read requests could be NEG_ACKEDed
      drbd: Log failures of connection state changes
      drbd: Restore late assigning of tconn->data.sock and meta.sock
      drbd: restart loop in drbd_make_request() [prepare for Linux-3.2]
      drbd: Fixed compat issue with disconnecting 8.4 from a primary 8.3
      drbd: Reinstate disabling AL updates with invalidate-remote
      drbd: Consider the disk-timeout also for meta-data IO operations
      drbd: If disk timeout expires fail only the affected volume
      drbd: Fix module refcount leak in drbd_accept()
      drbd: add missing part_round_stats to _drbd_start_io_acct
      drbd: Consider that bio->bi_bdev might be modified below DRBD
      drbd: Fixed processing of disk-barrier, disk-flushes and disk-drain
      drbd: Delay/reject other state changes while establishing a connection
      drbd: Ensure that data_size is not 0 before using data_size-1 as index
      drbd: fix spelling, remove boring development log message
      drbd: use bitmap_parse instead of __bitmap_parse
      drbd: Move the call to listen() out of drbd_accept()
      drbd: Remove drbd_accept() and use kernel_accept() instead
      drbd: New disk option al-updates
      drbd: pull prepare_listen_socket() out of drbd_wait_for_connect()
      drbd: Keep the listening socket open while trying to connect to the peer
      drbd: Remove redundant and wrong test for NULL simplification in conn_connect()
      drbd: Try to connec to peer only once per cycle
      drbd: More random to the connect logic
      drbd: Finish requests that completed while IO was frozen
      drbd: Fix completion of requests while the device is suspended
      drbd: Write all pages of the bitmap after an online resize
      drbd: Protect accesses to the uuid set with a spinlock
      drbd: Avoid NetworkFailure state during disconnect
      drbd: Remove dead code
      drbd: Fix a race condition that can lead to a BUG()
      drbd: Fix IO resuming after connection was established while executing the fence handler
      drbd: Improve readability of IO resuming after freeze due to no data access
      drbd: Do not check aspects that are not subject to change in _conn_requests_state()
      drbd: Fix the way the STATE_SENT bit is cleared
      drbd: Imporve the error reporting of failed conn state changes
      drbd: Fix postponed requests
      drbd: Call drbd_md_sync() explicitly after a state change on the connection
      drbd: Fix postponed requests
      drbd: Remove duplicate code
      drbd: Fix comparison of is_valid_transition()'s return code
      drbd: panic on delayed completion of aborted requests
      drbd: Fix clearing of MDF_AL_DISABLED
      drbd: fix regression: potential NULL pointer dereference
      drbd: don't try to clear bits once the disk has failed
      drbd: Broadcast sync progress no more often than once per second
      Merge branch 'drbd-8.4_ed6' into for-3.8-drivers-drbd-8.4_ed6

 drivers/block/drbd/Makefile        |    2 +
 drivers/block/drbd/drbd_actlog.c   |  689 +++----
 drivers/block/drbd/drbd_bitmap.c   |  227 ++-
 drivers/block/drbd/drbd_int.h      | 1398 ++++++-------
 drivers/block/drbd/drbd_interval.c |  207 ++
 drivers/block/drbd/drbd_interval.h |   40 +
 drivers/block/drbd/drbd_main.c     | 3883 ++++++++++++++----------------------
 drivers/block/drbd/drbd_nl.c       | 3378 ++++++++++++++++++-------------
 drivers/block/drbd/drbd_nla.c      |   55 +
 drivers/block/drbd/drbd_nla.h      |    8 +
 drivers/block/drbd/drbd_proc.c     |   33 +-
 drivers/block/drbd/drbd_receiver.c | 3883 +++++++++++++++++++++---------------
 drivers/block/drbd/drbd_req.c      | 1569 +++++++--------
 drivers/block/drbd/drbd_req.h      |  187 +-
 drivers/block/drbd/drbd_state.c    | 1857 +++++++++++++++++
 drivers/block/drbd/drbd_state.h    |  161 ++
 drivers/block/drbd/drbd_strings.c  |    1 +
 drivers/block/drbd/drbd_worker.c   | 1168 ++++++-----
 drivers/block/drbd/drbd_wrappers.h |   11 +-
 include/linux/drbd.h               |   81 +-
 include/linux/drbd_genl.h          |  378 ++++
 include/linux/drbd_genl_api.h      |   55 +
 include/linux/drbd_limits.h        |   90 +-
 include/linux/drbd_nl.h            |  164 --
 include/linux/drbd_tag_magic.h     |   84 -
 include/linux/genl_magic_func.h    |  422 ++++
 include/linux/genl_magic_struct.h  |  277 +++
 include/linux/idr.h                |   11 +
 include/linux/lru_cache.h          |   67 +-
 lib/lru_cache.c                    |  359 ++--
 30 files changed, 12115 insertions(+), 8630 deletions(-)
 create mode 100644 drivers/block/drbd/drbd_interval.c
 create mode 100644 drivers/block/drbd/drbd_interval.h
 create mode 100644 drivers/block/drbd/drbd_nla.c
 create mode 100644 drivers/block/drbd/drbd_nla.h
 create mode 100644 drivers/block/drbd/drbd_state.c
 create mode 100644 drivers/block/drbd/drbd_state.h
 create mode 100644 include/linux/drbd_genl.h
 create mode 100644 include/linux/drbd_genl_api.h
 delete mode 100644 include/linux/drbd_nl.h
 delete mode 100644 include/linux/drbd_tag_magic.h
 create mode 100644 include/linux/genl_magic_func.h
 create mode 100644 include/linux/genl_magic_struct.h

