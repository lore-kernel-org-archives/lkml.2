Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab1HXOl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 10:41:58 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:60842 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab1HXOly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 10:41:54 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] drbd-8.4 for mainline
Date: Wed, 24 Aug 2011 16:41:42 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-generic; KDE/4.6.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201108241641.42676.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

First the announcement of drbd-8.4, then the git pull-request text:

We are proud to announce the availability of DRBD-8.4.0.

  The most noticeable change is the support for multiple replicated
  volumes in a single DRBD connection.
  Write-ordering is obeyed among all writes in all volumes in a
  single connection.
  This feature is really important for users who DRBD for mirroring
  over longer distances. (Protocol A).

We do not only release DRBD-8.4.0 today:
The DRBD User's Guide was reviewed and updated to match DRBD-8.4.

I suggest to everybody who considers to upgrade from 8.3 to 8.4
to have a look at the "Recent changes" appendix of the UG:
http://www.drbd.org/users-guide/ap-recent-changes.html

  This release brings a new meta-data format. Forward (8.3 -> 8.4)
  conversion happens complete seamless. Backward conversion
  is done by a single command (drbdadm apply-al res).

  This release is protocol compatible with all it predecessor. 
  Although, we do not recommend to run it in 8.3 - 8.4 for long
  time frames. We recommend to use that capability only for the
  rolling upgrade.

  drbdadm of 8.4 can parse config files of 8.3. We recommend
  to switch to the new configuration syntax after the upgrade
  of both nodes. (Use drbdadm dump to learn about the new
  config syntax)


8.4.0 (api:genl1/proto:86-100)
--------
 * Fixed handling of read errors during online verify
 * Fix for connecting on high latency network links
 * Fixed state transitions if fence-peer handler returns after connection was
   established again
 * Go into inconsistent disk state with on-io-error=pass-on policy
 * Timeouts for requests processing on the peer (previously that
   worked only if the data socket was congested)
 * Reworked Linux backward compatibility mechanism
 * Conflicting write detection is now based on an interval tree,
   removed the hash-tables (necessary for the unlimited BIO sizes)
 * Removed the tracing framework
 * Support for multiple volumes (minors, block devices) per connection;
   up to 65536 volumes per connection supported
 * Reduced IO latencies during some state changes (esp. start resync)
 * New on disk format for the AL: double capacity; 4k aligned IO; same space
 * Multiple AL changes in a single transaction (precondition for
   unlimited BIO sizes)
 * DRBD no longer imposes any limit on BIO sizes
 * Removed DRBD's limits on the number of minor devices
 * DRBD's minors can now be removed (not only unconfigured)
 * Switched the user space interface form connector to generic netlink
 * drbdadm, configuration changes: volume sections; syncer section removed;
   bool options got yes/no values, that improves option inheritance;
   resource options
 * drbdsetup: new commands for creating and removing resources
   and minors
 * drbdsetup: new commands for changing disk options while the disk
   is attached; ...for changing net options while the connection is
   established
 * drbdsetup/drbdadm the wire-protocol is now a regular connection option
 * Removed drbdadm option --force
 * IO freezing/thawing is done on connection (all volumes) level
 * fencing is done on connection (all volumes) level
 * Enforce application of activity log after primary crash in user space
 * Features from drbd-8.3: Allow detach from frozen backing devices with the
   new --force option; configurable timeout for backing devices by the new
   disk-timeout option
 * Renamed --dry-run of connect to --tentative; plus alias in drbdsetup
 * drbdadm got a "help" sub command, that shows the specific options
 * drbdadm now knows all drbdsetup options, and verify ...
 * drbdadm can now process all options in random order, and ignores the "--"
   separator; compatibility aliases with the old calling conventions; now it
   is compatible with the pre 8.4 way of calling.
 * New default values (compared to drbd-8.3) for: minor-count, ko-count, al-extents,
   c-plan-ahead, c-fill-target, c-min-rate, use-rle, on-io-error



The following changes since commit e03c8dd14915fabc101aa495828d58598dc5af98:

  loop: always allow userspace partitions and optionally support automatic scanning 
(2011-08-23 20:12:04 +0200)

are available in the git repository at:
  git://git.drbd.org/linux-2.6-drbd.git for-jens

Andreas Gruenbacher (214):
      drbd: Get rid of req_validator_fn typedef
      drbd: Remove superfluous declaration
      drbd: Consistently use block_id == ID_SYNCER for checksum based resync and online 
verify
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
      drbd: drbd_send_uuids() and its variants: Return 0 upon success and an error code 
otherwise
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
      drbd: drbd_send_drequest(): Return 0 upon success and an error code otherwise
      drbd: drbd_send_drequest_csum(): Return 0 upon success and an error code otherwise
      drbd: drbd_send_oos(): Return 0 upon success and an error code otherwise
      drbd: _drbd_no_send_page(): Return 0 upon success and an error code otherwise
      drbd: _drbd_send_page(): Return 0 upon success and an error code otherwise
      drbd: _drbd_send_zc_ee(): Return 0 upon success and an error code otherwise
      drbd: drbd_send_block(): Return 0 upon success and an error code otherwise
      drbd: _drbd_send_bio(), _drbd_send_zc_bio(): Return 0 upon success and an error code 
otherwise
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
      drbd: send_protocol(): Wrong size sent
      drbd: drbd_connect(): Initialize struct drbd_socket before sending anything
      drbd: _conn_send_cmd(), _drbd_send_cmd(): Pass a struct drbd_socket instead of a 
plain socket
      drbd: Change how the initial packets are called
      drbd: Change how the "handshake" packets are called
      drbd: Do not free tconn->cpu_mask when freeing a device
      drbd: drbd_send_ping(), drbd_send_ping(): Return 0 upon success and an error code 
otherwise
      drbd: Introduce new primitives for sending commands
      drbd: Introduce drbd_header_size()
      drbd: Replace and remove old primitives
      drbd: Remove now-unused int_dig_out buffer
      drbd: Remove some fixed header size assumptions
      drbd: Remove headers from on-the-wire data structures (struct p_*)
      drbd: Introduce protocol version 100 headers
      drbd: Remove volume numbers from struct p_header95
      drbd: For protocol versions before 100, use mixed header versions
      drbd: validate_req_change_req_state(): Return 0 upon success and an error code 
otherwise
      drbd: Make all asynchronous command handlers return 0 upon success and an error code 
otherwise
      drbd: drbd_init_ee() no longer exists
      drbd: Rename drbd_alloc_ee() to drbd_alloc_peer_req()
      drbd: Rename drbd_free_ee() and variants to *_peer_req()
      drbd: Rename drbd_release_ee() to drbd_free_peer_reqs()
      drbd: Rename reclaim_net_ee(), drbd_process_done_ee(), drbd_process_done_ee(), 
tconn_process_done_ee() to *_peer_reqs
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
      drbd: Turn no-disk-barrier into disk-barrier={yes|no}
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
      drbd: drbd_nla_check_mandatory(): Need to remove the DRBD_GENLA_F_MANDATORY flag 
first
      drbd: drbd_adm_prepare(): Pass through error codes
      drbd: Don't use empty nested netlink attributes
      drbd: Define and use DRBD_VOLUME_MAX
      drbd: Use DRBD_MINOR_COUNT_DEF in one more place
      drbd: Use the terminology suggested by the command names in the source code and 
messages
      drbd: Also need to check for DRBD_GENLA_F_MANDATORY flags before nla_find_nested()
      drbd: Split off netlink mandatory attribute handling into separate file
      drbd: Another netlink backward compatibility fix
      drbd: Rename DRBD_ADM_NEED_{CONN -> RESOURCE}
      drbd: Convert the generic netlink interface to accept connection endpoints
      drbd: Allow to pass resource options to the new-resource command
      drbd: Fix the duplicate connection endpoint check
      drbd: Remove dead code
      drbd: Rename --dry-run to --tentative
      drbd: DRBD_ADM_GET_STATUS: Return the host and peer address
      drbd: Improve the "unexpected packet" error messages
      drbd: Fix typo in error message
      drbd: config_unknown_volume(): Improve warning message
      drbd: Define scale factors in a single place
      drbd: Fix the maximum accepted minor device number
      drbd: Allow to create devices with a minor number > minor_count
      drbd: Error reporting fix for DRBD_ADM_NEW_MINOR and DRBD_ADM_CONNECT
      drbd: Print memory address in hex instead of decimal in error message
      drbd: receive_protocol(): Give variables more easily searchable names
      drbd: receive_protocol(): Make the program flow less confusing
      drbd: Be consistent in reporting incompatibilities in P_PROTOCOL settings
      drbd: receive_protocol(): We cannot change our own data-integrity-alg setting here
      drbd: Turn tl_apply() into tl_abort_disk_io()
      drbd: Update some outdated comments to match the code
      drbd: Improve error reporting in drbd_md_sync_page_io()

David Howells (1):
      DRBD: Fix comparison always false warning due to long/long long compare

Lars Ellenberg (85):
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
      drbd: don't forget to add_disk()
      drbd: fix detach path
      drbd: remove unused define
      drbd: default to detach on-io-error
      drbd: only wakeup if something changed in update_peer_seq
      drbd: add page pool to be used for meta data IO
      drbd: use the newly introduced page pool for bitmap IO
      drbd: introduce a bio_set to allocate housekeeping bios from
      drbd: fix drbd_delete_device: remove vnr from volumes; idr_remove(); 
synchronize_rcu(); before cleanup
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
      drbd: fix NULL pointer dereference in drbd_adm_attach
      drbd: disable genl_magic_* printk debugging by default
      drbd: revert nlm_flag extension for "change" commands
      drbd: network addresses are binary fields
      drbd: if received size matches expected size, that's not an error
      drbd: fix compiler warnings about comparison between different enum types
      drbd: fix dereference of uninitialized values in error path
      drbd: introduce the "initialized" activity log transaction type
      drbd: preparation commit, pass drbd_interval to drbd_al_begin/complete_io
      drbd: prepare to activate two activity log extents at once
      drbd: get rid of bio_split, allow bios of "arbitrary" size
      drbd: improvements to activate/deactivate multiple activity log extents
      drbd: allow status dump request all volumes of a specific resource
      drbd: fix off-by-one error in buffer size calculation
      drbd: fix leaving drbd_adm_net_opts with CONFIG_PENDING bit still set
      drbd: fix get_ldev()/put_ldev() imbalance
      drbd: fix _drbd_send_ack returning with the sock mutex held
      drbd: fix setsockopt for user mode linux
      drbd: fix typo: mutex_UNlock in error-out path of receive_SyncParam
      drbd: fix copy/paste error in drbd_send_drequest_csum
      drbd: cmdname() enum to string convertion was missing a few constants
      drbd: move comment about stopping the receiver thread to where it belongs
      drbd: remove useless kobject_uevent from drbd_adm_connect
      drbd: fix various disconnecting races
      drbd: on reconfiguration requests, mind the SET_DEFAULTS flag
      drbd: rename variable ndc to new_disk_conf
      drbd: rename variable sc to res_opts
      drbd: add missing spin_lock in w_al_write_transaction
      drbd: fix copy/paste error in comment
      drbd: convert conn_printk() to a macro
      drbd: fix drbd_send_b_ack returning with the meta sock mutex held
      drbd: fix typo in macro argument
      drbd: fix race when forcefully disconnecting
      drbd: fix thread stop deadlock
      drbd: fix access after free
      drbd: fix schedule in atomic
      drbd: fix attaching with internal metadata, meta_dev_idx is signed
      drbd: skip spurious wait_event in drbd_al_begin_io
      drbd: add paranoia range check in drbd_bm_mark_for_writeout
      drbd: cosmetic: fix accidental division instead of modulo when pretty printing
      drbd: spelling fix: too small
      drbd: allow ping-timeout of up to 30 seconds
      drbd: downgraded error printk to info
      drbd: on attach, enforce clean meta data
      drbd: do not require MDF_PRIMARY_IND to be cleared on attach
      drbd: fix refrence count mismatch during meta data IO and GFP_KERNEL -> GFP_NOIO
      drbd: fix regression: forget the network addresses on disconnect
      drbd: report net config even for resources without a single volume
      drbd: remove obsolete code on attach
      drbd: detach must not try to abort non-local requests
      drbd: fix connect failure with all default net-options

Philipp Reisner (199):
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
      drbd: Use new header layout, and send volume IOs
      drbd: Implemented receiving of new style packets on meta socket
      drbd: Do not access tconn after it was freed
      drbd: Moved the state functions into its own source file
      drbd: Moved the thread name into the data structure
      drbd: Eliminated the user of drbd_task_to_thread()
      drbd: Moved code
      drbd: Do no sleep long in drbd_start_resync
      drbd: Revert "Make sure we dont send state if a cluster wide state change is in 
progress"
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
      drbd: Converted drbd_connect() from mdev to tconn
      drbd: Converted drbd_calc_cpu_mask() and drbd_thread_current_set_cpu() from mdev to 
tconn
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
      drbd: Implemented conn_send_state_req()
      drbd: Global_state_lock not necessary here...
      drbd: Implemented conn_send_sr_reply()
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
      drbd: Do not modify the connection state with something else that 
conn_request_state()
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
      drbd: Completely initialize the disk_conf, net_conf and res_opts
      drbd: Use the idr_for_each_entry() iterator instead of idr_for_each()
      drbd: Fixed copy'n'paste error in conn_highest_peer()
      drbd: Fixed logging of old connection state
      drbd: Print common state changes of all volumes as connection state changes
      drbd: vnr_to_mdev() must be called with a volume number
      drbd: Allow to disconnect if one volume is diskless
      drbd: Do not access ldev members unprotected
      drbd: Do not segfault if a sync dependency reaches a diskless device
      drbd: Fixed typo in drbd_connect()
      drbd: Introduced drbd_read_state()
      drbd: Renamed id_susp(union drbd_state s) to drbd_suspended(struct drbd_conf *)
      drbd: Moved susp, susp_nod and susp_fen to the connection object
      drbd: Introduced a new type union drbd_dev_state
      drbd: Renamed nms to ns_max
      drbd: Calculate and provide ns_min to the w_after_conn_state_ch() work
      drbd: Implemented conn_lowest_conn()
      drbd: Implemented conn_lowest_disk()
      drbd: Fixed IO thawing for multiple volumes
      drbd: Fixed conn_request_state() for use with conn.mask = 0
      drbd: Improved logging of state changes
      drbd: Use tconn in request_timer_fn()
      drbd: Fixed the error paths in conn_new_minor
      drbd: drbd_delete_device() takes a struct drbd_conf * now
      drbd: Inlined drbd_free_mdev(); it got called only from one place
      drbd: rcu_read_[un]lock() for all idr accesses that do not sleep
      drbd: Converted drbd_cfg_mutex into drbd_cfg_rwsem
      drbd: protect all idr accesses that might sleep with drbd_cfg_rwsem
      drbd: Runtime changeable wire protocol
      drbd: Check consistency of net options when the get changed online
      drbd: Allow online change of replication protocol only with agreed_pv >= 100
      drbd: Fix the use of drbd_cfg_rwsem in drbd_adm_down()
      drbd: Fixed drbd_send_state_req()
      drbd: Fixed drbd_send_sr_reply() and conn_send_sr_reply()
      drbd: rcu_read_lock() and rcu_dereference() for tconn->net_conf
      drbd: Proper locking for updates to net_conf under RCU
      drbd: Considering that the two_primaries config flag can change
      drbd: Fix, the worker might run even if there is no net conf
      drbd: Eliminated drbd_free_resoruces() it is superseeded by conn_free_crypto()
      drbd: Basic refcounting for drbd_tconn
      drbd: Take a reference on tconn when finding a tconn by name
      drbd: Removed the OBJECT_DYING and the CONFIG_PENDING bits
      drbd: Do not access after free in w_e_end_ov_req()
      drbd: Consider all crypto options in connect and in net-options
      drbd: HARD state changes do not require the agreement of the peer
      drbd: Removed dead code
      drbd: Renamed the net_conf_update mutex to conf_update
      drbd: drbd_dew_dev_size() gets the user requests disk_size as argument
      drbd: Split drbd_alter_sa() into drbd_sync_after_valid() and 
drbd_sync_after_changed()
      drbd: Renamed (old|new)_conf into (old|new)_net_conf in receive_SyncParam
      drbd: RCU for disk_conf
      drbd: Made the fifo object a self contained object (preparing for RCU)
      drbd: Enforce limits of disk_conf members; centralized these checks
      drbd: RCU for rs_plan_s
      drbd: Bugfix for receive_SyncParam()
      drbd: Refcounting for mdev objects
      drbd: Use RCU for the drbd_tconns list
      drbd: Do not sleep while holding rcu_read_lock()
      drbd: Use printk() consistently
      drbd: Fixed enum type of conn_lowest_conn()
      drbd: Fixed conn_highest_peer()
      drbd: Refuse to change network options online when...
      drbd: protect updates to integrits_tfm by tconn->data->mutex
      drbd: Made cmp_after_sb() more generic into convert_after_sb()
      drbd: Allocation of int_dig_in and int_dig_vv was missing
      drbd: Receiving part for the PROTOCOL_UPDATE packet
      drbd: Send PROTOCOL_UPDATE packets when appropriate
      drbd: Hold a reference to tconn while running the outdate_peer_handler asynchronously
      drbd: Do not clear suspend flag when the fence-peer handler returns
      drbd: Fixing use of max_t() on roles
      drbd: Fixed state transitions after async outdate-peer-handler returned
      drbd: fix warning
      drbd: Lower log priority for an event that is definitely not an error
      drbd: Reduced verbosity
      drbd: Moved prototypes of tl_restart()
      drbd: Fixes from the 8.3 development branch
      drbd: Improve compatibility with drbd's older than 8.3.7
      drbd: Consider compatibility between drbd-8.3.10 and drbd-8.4.0
      drbd: Fixed state transitions in case reading meta data failes
      drbd: detach from frozen backing device
      drbd: Use dev_warn() instead of WARN()
      drbd: Fixed removal of volumes/devices from connected resources
      drbd: Moved del_timer(request_timer) to the right place
      drbd: Eliminated the "notified peer" messages
      drbd: Correctly handle resources without volumes
      drbd: Do not return pointer to local variables
      drbd: Changed some defaults
      drbd: Do not allocate memory while holding rcu_read_lock()
      drbd: Always call the local-io-error handler upon a disk timeout
      drbd: Fixed two race conditions in the state engine
      drbd: Dropped wrong clause to generate new current UUIDs
      drbd: Consider that the no-data-condition could be in connected state
      drbd: Do not mod_timer() with a past time
      drbd: Missing assignment of mdev before drbd_queue_work()
      drbd: Fixed w_restart_disk_io() to handle non active AL-extents
      drbd: Do not display bogus log lines for pdsk in case pdsk < D_UNKNOWN
      drbd: The minor_count module parameter is only a hint nowadays
      drbd: Cleanup all epoch objects upon connection loss
      drbd: Remove dead code
      drbd: Remove unused code

 drivers/block/drbd/Makefile        |    2 +
 drivers/block/drbd/drbd_actlog.c   |  706 ++++-----
 drivers/block/drbd/drbd_bitmap.c   |  300 +++-
 drivers/block/drbd/drbd_int.h      | 1250 ++++++--------
 drivers/block/drbd/drbd_interval.c |  177 ++
 drivers/block/drbd/drbd_interval.h |   40 +
 drivers/block/drbd/drbd_main.c     | 3372 ++++++++++++++---------------------
 drivers/block/drbd/drbd_nl.c       | 3355 +++++++++++++++++++++--------------
 drivers/block/drbd/drbd_nla.c      |   55 +
 drivers/block/drbd/drbd_nla.h      |    8 +
 drivers/block/drbd/drbd_proc.c     |   27 +-
 drivers/block/drbd/drbd_receiver.c | 3439 +++++++++++++++++++++---------------
 drivers/block/drbd/drbd_req.c      |  746 ++++-----
 drivers/block/drbd/drbd_req.h      |  185 +--
 drivers/block/drbd/drbd_state.c    | 1749 ++++++++++++++++++
 drivers/block/drbd/drbd_state.h    |  161 ++
 drivers/block/drbd/drbd_strings.c  |    1 +
 drivers/block/drbd/drbd_worker.c   |  976 ++++++-----
 drivers/block/drbd/drbd_wrappers.h |   11 +-
 include/linux/drbd.h               |   68 +-
 include/linux/drbd_genl.h          |  363 ++++
 include/linux/drbd_genl_api.h      |   55 +
 include/linux/drbd_limits.h        |   95 +-
 include/linux/drbd_nl.h            |  160 --
 include/linux/drbd_tag_magic.h     |   84 -
 include/linux/genl_magic_func.h    |  414 +++++
 include/linux/genl_magic_struct.h  |  277 +++
 include/linux/idr.h                |   11 +
 include/linux/lru_cache.h          |   67 +-
 lib/lru_cache.c                    |  359 +++--
 30 files changed, 11017 insertions(+), 7496 deletions(-)
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

Best,
 Phil
-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.
